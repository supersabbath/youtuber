//
//  VideoCollectionCell.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCollectionCell: UICollectionViewCell {

    @IBOutlet var thumbnailImageView: UIImageView!
    var viewModel:Video? {
        didSet {
//            let disposeBag = DisposeBag()

            guard let model = viewModel else { return } // same cell

            thumbnailImageView.kf.setImage(with: model.thumbNails?.imageUrl)
        }
    }
    override func awakeFromNib() {

        let bottomGradient = CAGradientLayer()
        bottomGradient.frame = CGRect(x: 0, y: self.bounds.height - 60, width: self.bounds.width, height: 60)
        bottomGradient.colors = [UIColor.clear,  UIColor.black.withAlphaComponent(0.3).cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        self.layer.addSublayer(bottomGradient)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        self.viewModel = nil
      //  self.disposeBag = nil
    }
}
