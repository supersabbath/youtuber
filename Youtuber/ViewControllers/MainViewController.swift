//
//  ViewController.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import youtube_ios_player_helper

class MainViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: Dependencies & Rx
    let searchServices =  YoutubeSearchAPI(with: Config())
    var navbarSubject = PublishSubject<Bool>()
    private var resignKeyboard: AnyObserver<Void> {
        return Binder(self) { me, _ in
            me.searchBar.resignFirstResponder()
            }.asObserver()
    }
    let disposeBag = DisposeBag()
    // MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowlayout()
        let observableResults = setupRXSearchBar()
        setupRXCollectionView(searchResults: observableResults)
        driveUIElements(searchResults: observableResults)
    }

    func setupFlowlayout() {
        let layout = UICollectionViewFlowLayout()
        let width = collectionView.frame.width * 0.9
        layout.itemSize = CGSize(width: width , height: width * 0.5625 )
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "player_segue" {
            if let player = segue.destination as? YoutubePlayerViewController , let model = sender as? Video {
                player.model = model
            }
        }
    }

    // MARK: Rx Components
    func setupRXSearchBar() -> Observable<[Video]> {

        let searchResult = searchBar.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[Video]> in
                if query.isEmpty { return .just([]) }
                return self.searchServices.search(queryText: query)
                    .do(onNext: { tupple in
                        self.navbarSubject.onNext(false)
                    }, onError: { (error) in
                        self.navbarSubject.onNext(true) // change the color of the navbar if error occurs
                    }).map({ response -> [Video]  in
                        switch response {
                        case .success(let videos):
                            return videos
                        case .failure(let error):
                            print(error)
                            self.view.viewWithTag(123)?.isHidden = false
                            return []
                        }
                    })
            }.observeOn(MainScheduler.instance)
        // Hide keyboard
        Observable.merge(searchBar.rx.cancelButtonClicked.asObservable(),
                         searchBar.rx.searchButtonClicked.asObservable())
            .bind(to: resignKeyboard)
            .disposed(by: disposeBag)

        return searchResult
    }

    func setupRXCollectionView( searchResults: Observable<[Video]> ){
        
        searchResults.catchErrorJustReturn([])
            .bind(to:  self.collectionView.rx.items(cellIdentifier: "cell_id" , cellType:VideoCollectionCell.self)) { (_ , model, cell) in
                model.getDuration(use: self.searchServices)
                cell.viewModel = model
                model.durationVariable.asDriver()
                .drive(cell.infoView.durationLabel.rx.text)
                .disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)

        collectionView.rx.itemSelected.asObservable().subscribe(onNext: { (indexPath) in
            let model = ( self.collectionView.cellForItem(at: indexPath) as! VideoCollectionCell).viewModel
            self.performSegue(withIdentifier: "player_segue", sender: model)
        }).disposed(by: disposeBag)
    }

    func driveUIElements( searchResults: Observable<[Video]> ) {
        // Drive the label and the keyboard accordign to response
        searchResults.asDriver(onErrorJustReturn: []).drive(onNext: { (videos) in
            guard let label = self.view.viewWithTag(123) else { return }
            UIView.transition(with: label, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                label.isHidden = !videos.isEmpty
            }, completion: nil)
            Observable.just(videos.isEmpty)
                .map{ $0 }
                .bind(to: self.resignKeyboard)
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        // Navbar error
        navbarSubject.asDriver(onErrorJustReturn: false)
            .map{ $0 }
            .drive(navigationController!.rx.isOffline)
            .disposed(by: disposeBag)
    }
}

