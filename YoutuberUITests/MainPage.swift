//
//  MainPage.swift
//  YoutuberUITests
//
//  Created by Fernando Cañón on 10/7/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import UIKit
import XCTest

class MainPage: PageObject {

    var searchBar: XCUIElement {
        return app.otherElements.containing(.navigationBar, identifier:"The Amazing Youtube App").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element
    }

    var collectionViewCells:XCUIElement {
        return app.collectionViews.children(matching: .cell).element(boundBy: 1)
    }

    func typeInSearchBar() {
        searchBar.tap()
        searchBar.typeText("soccer")
    }
}


class PageObject: NSObject {

    let app:XCUIApplication

    init(withApp app:XCUIApplication) {
        self.app = app
        super.init()
    }

    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
