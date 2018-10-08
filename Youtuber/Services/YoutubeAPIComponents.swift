//
//  YoutubeAPI.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/7/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import Foundation
import RxSwift

enum Result<T, E: Error>  {
    case success(T)
    case failure(E)
}

typealias SearchResponse = Result<[Video], YoutubeServiceError>

protocol YoutubeAPI {
    func search(queryText:String) -> Observable<SearchResponse>
    func fetchContentDetails(for videoId:String) -> Observable<ContentDetails?>
}
