//
//  VideoCollectionCell.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class VideoCollectionCell: UICollectionViewCell {

    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet weak var infoView: InfoView!
    let bottomGradient = CAGradientLayer()
    var disposeBag: DisposeBag?
    var viewModel:Video? {
        didSet {
            guard let model = viewModel else { return } // same cell
            let processor = BlurImageProcessor(blurRadius: 2) >> RoundCornerImageProcessor(cornerRadius: 20)
            thumbnailImageView.kf.setImage(with: model.thumbNails?.imageUrl, placeholder: nil, options: [.processor(processor),.transition(.fade(0.2))])
            infoView.titleLabel.text = model.title
            infoView.channelTitleLabel.text = model.channelTitle
            infoView.publishedDate.text = model.publishedDate

        }
    }

    override func awakeFromNib() {
        bottomGradient.colors = [UIColor.clear,  UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.black.withAlphaComponent(0.99).cgColor]
        bottomGradient.cornerRadius = 20
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bottomGradient.frame = infoView.bounds
        self.infoView.layer.insertSublayer(bottomGradient, at: 0)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
    }
}
