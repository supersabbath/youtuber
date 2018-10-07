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

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let searchServices =  YoutubeSearchAPI()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupReactiveSearchBar()
    }

    func setupReactiveSearchBar(){

        let searchResult = searchBar.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[Video]> in
                if query.isEmpty {
                    return .just([])
                }
                return self.searchServices.search(queryText: query).map({ response -> [Video]  in
                    switch response {
                    case .success(let videos):
                        return videos
                    case .failure(let error):
                        print(error)
                        return []
                    }
                })
            }.observeOn(MainScheduler.instance)
        
        searchResult.bind(to:  self.collectionView.rx.items(cellIdentifier: "cell_id" , cellType:VideoCollectionCell.self)) { (_ , model, cell) in
            
            cell.viewModel = model
            }.disposed(by: self.disposeBag)

    }
}


import RxSwift
import RxCocoa

struct Colors {
    static let offlineColor = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
    static let onlineColor = nil as UIColor?
}

extension Reactive where Base: UINavigationController {
    var isOffline: Binder<Bool> {
        return Binder(base) { navigationController, isOffline in
            navigationController.navigationBar.barTintColor = isOffline
                ? Colors.offlineColor
                : Colors.onlineColor
        }
    }
}
