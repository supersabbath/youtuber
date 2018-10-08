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


enum Result<T, E: Error>  {
    case success(T)
    case failure(E)

}

enum YoutubeServiceError: Error {
    case offline
    case queryLimitReached
    case badRequest
    case networkError
}

typealias SearchResponse = Result<[Video], YoutubeServiceError>

protocol YoutubeAPI {

    func search(queryText:String) -> Observable<SearchResponse>
    func fetchContentDetails(for videoId:String) -> Observable<ContentDetails?>
}

class YoutubeSearchAPI<T:ApiConfiguration>: NSObject {

    let config:T

    required init(with configuration:T){
        config = configuration
    }

    let serialQueue = SerialDispatchQueueScheduler(qos: .default) // no need just show how to handle background quees

    func search(queryText:String) -> Observable<SearchResponse> {

        let stringUrl = "\(config.youTubeApiUrl)search?part=snippet&q=\(queryText.replaceWhiteSpace(with: "+"))&type=video&maxResults=10&key=\(config.apiKey)"
        guard let searchURL = URL(string: stringUrl) else { return Observable.empty() }
        return URLSession.shared
            .rx.response(request:  URLRequest(url: searchURL))
            .observeOn(serialQueue)
            .map{ response -> SearchResponse in
                guard response.response.statusCode != 403  else {
                    return .failure(.queryLimitReached)
                }
                guard response.response.statusCode != 400 else {
                    return .failure(.badRequest)
                }
                let jsonResponse = try self.parseJSON(response.response, data: response.data) ?? [:]
                let videos =  Mapper<Video>().mapArray(JSONObject: jsonResponse["items"]) ?? []
                return .success(videos)
            }
    }


    func fetchContentDetails(for videoId:String) -> Observable<ContentDetails?> {

        let contentDetailUrl =  "\(config.youTubeApiUrl)videos?part=contentDetails&id=\(videoId)&fields=items(contentDetails(countryRestriction%2Cduration))&key=\(config.apiKey)"

        guard let videosURL = URL(string: contentDetailUrl) else { return Observable.empty() }

        return URLSession.shared
            .rx.response(request:  URLRequest(url: videosURL))
            .observeOn(serialQueue)
            .map{ response -> ContentDetails? in
                guard !(400 ..< 410 ~= response.response.statusCode)   else {
                    throw YoutubeServiceError.badRequest
                }
                let jsonResponse = try self.parseJSON(response.response, data: response.data) ?? [:]
                let contentDetails =  Mapper<ContentDetails>().mapArray(JSONObject: jsonResponse["items"]) ?? []
                return contentDetails.first
        }
    }


    fileprivate func parseJSON(_ httpResponse: HTTPURLResponse, data: Data) throws -> [String : Any]?  {
        if !(200 ..< 300 ~= httpResponse.statusCode) {
            throw YoutubeServiceError.networkError
        }
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
    }
}
