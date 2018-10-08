//
//  YoutuberUITests.swift
//  YoutuberUITests
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import XCTest

class YoutuberUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    /**
        This UI test shows how to test the UI, I use PageModeObject design pattenr, it is useful to create reusables
        XCUIElement for each viewcontroller. The Idea is to map each UI Element in de VC to a Page element. 
     */
    func testLauncPlayer()  {
        let app = XCUIApplication()
        let mainViewControllerPage = MainPage(withApp: app)
        mainViewControllerPage.typeInSearchBar()
        waitForElementToAppear(mainViewControllerPage.collectionViewCells)
        mainViewControllerPage.collectionViewCells.tap()
        // this element should be in another PapeObject. For instance: PlayerPage. This is just a demo
        let playerBackButton = app.navigationBars["Youtuber.YoutubePlayerView"].buttons["The Amazing Youtube App"]
        waitForElementToAppear(playerBackButton)
        XCTAssertTrue(playerBackButton.exists, "The player should had been opened")
        playerBackButton.tap()
        waitForElementToAppear(mainViewControllerPage.searchBar)
        XCTAssertTrue(mainViewControllerPage.searchBar.exists, "The app should have closed the player")
    }

    func testSearchBarAndCollectionViewConection() {

        let app = XCUIApplication()
        let mainViewControllerPage = MainPage(withApp: app)
        // Test that we ah
        XCTAssertTrue(mainViewControllerPage.searchBar.exists, "The app should have a search bar ")
        mainViewControllerPage.typeInSearchBar()
        waitForElementToAppear(mainViewControllerPage.collectionViewCells)
        // Test that the collection view exists
        XCTAssertTrue(mainViewControllerPage.collectionViewCells.exists , "The collection view is not responding on doesnt exists")
        mainViewControllerPage.collectionViewCells.swipeUp()
        mainViewControllerPage.collectionViewCells.swipeUp()
        mainViewControllerPage.collectionViewCells.swipeUp()

        // Test that we had 10 cells as requested in the requirements
        XCTAssertGreaterThan(app.collectionViews.children(matching: .cell).count, 3, " There should more than 3 cells" )
    }
}

extension XCTestCase {

    func waitForElementToAppear(_ element: XCUIElement, file: String = #file, line: UInt = #line , waitTime:TimeInterval = 30.0) {

        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: waitTime) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 30 seconds."
                self.recordFailure(withDescription: message,
                                   inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
}


