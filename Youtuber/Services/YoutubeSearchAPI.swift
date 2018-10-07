//
//  YoutubeSearchAPI.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import struct Foundation.URL
import struct Foundation.Data
import struct Foundation.URLRequest
import struct Foundation.NSRange
import class Foundation.HTTPURLResponse
import class Foundation.URLSession
import class Foundation.NSRegularExpression
import class Foundation.JSONSerialization
import class Foundation.NSString
import RxSwift
import RxCocoa
import ObjectMapper


enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum YoutubeServiceError: Error {
    case offline
    case queryLimitReached
    case networkError
}

typealias SearchResponse = Result<[Video], YoutubeServiceError>


class YoutubeSearchAPI: NSObject {

    let serialQueue = SerialDispatchQueueScheduler.init(qos: .default) // no need just show how to handle background quees

    func search(queryText:String) -> Observable<SearchResponse> {

        let stringUrl = "\(Config.youTubeApiUrl)search?part=snippet&q=\(queryText.replaceWhiteSpace(with: "+"))&type=video&maxResults=10&key=\(Config.apiKey)"

        guard let searchURL = URL(string: stringUrl) else { return Observable.empty() }

        return URLSession.shared
            .rx.response(request:  URLRequest(url: searchURL))
            .observeOn(serialQueue)
            .map{ response -> SearchResponse in
                guard response.response.statusCode != 403  else {
                    return .failure(.queryLimitReached)
                }
                let jsonResponse = try self.parseJSON(response.response, data: response.data) ?? [:]
                let videos =  Mapper<Video>().mapArray(JSONObject: jsonResponse["items"]) ?? []
                return .success(videos)
        }
    }

    fileprivate func parseJSON(_ httpResponse: HTTPURLResponse, data: Data) throws -> [String : Any]?  {
        if !(200 ..< 300 ~= httpResponse.statusCode) {
            throw YoutubeServiceError.networkError
        }
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
    }
}
