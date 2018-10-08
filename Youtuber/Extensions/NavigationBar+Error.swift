//
//  NavigationBar+Error.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/7/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//


import UIKit.UINavigationBar
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

