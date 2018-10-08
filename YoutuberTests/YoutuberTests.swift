//
//  YoutuberTests.swift
//  YoutuberTests
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
import ObjectMapper

@testable import Youtuber

class YoutuberTests: XCTestCase {

    let sut = YoutubeSearchAPI(with: MockConfig()) // Subject Under Test
    var disposeBag = DisposeBag()
    /**
         This just a simple example on how I will test the YoutubeSearchAPI service. I know it's not correct to do unit
        test using a real connection to the server, but for the task at hand , I think its enough to show how I would have
        done it. First of all YoutubeSearchAPI Class is open to dependency inyection , Using generics and Protocol, that
        allows me to introduce a mock that to test the expecte behaviour. In this case changin the API KEY.

        For a production test , I would have mock either the API service or the URLSession classs.
     */
    func test_searchAPI_40x_http_response() {
        let exp = self.expectation(description: "test_403_http_reponse")
        sut.search(queryText: "go play").subscribe(onNext: { searchResult in
            switch searchResult {
                case .failure(let error):
                    XCTAssertEqual(error, YoutubeServiceError.badRequest)
            case .success(let _):
                    XCTFail()
            }
            exp.fulfill()
        }).disposed(by: disposeBag)

        self.waitForExpectations(timeout: 10) { (error) in
            print("time out test_403_http_reponse()")
        }
    }

    func testGetContentDetails_40x_error() {
        let exp = self.expectation(description: "testGetContentDetails_40x_error")
        sut.fetchContentDetails(for: "noid").subscribe { (event) in
            switch event{
                case .error(let error):
                    XCTAssertTrue((error is YoutubeServiceError))
                default:
                    XCTFail()
                break
            }
            exp.fulfill()
        }.disposed(by: disposeBag)
        self.waitForExpectations(timeout: 10) { (error) in
            print("time out test_403_http_reponse()")
        }
    }
}

class MockConfig: ApiConfiguration {
    var youTubeApiUrl: String = "https://www.googleapis.com/youtube/v3/"
    var apiKey: String = "Enjoy_life"
}
