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


class YoutubeSearchAPI<T:ApiConfiguration>: NSObject {

    let config:T
    private let serialQueue = SerialDispatchQueueScheduler(qos: .default) // no need just show how to handle background quees
    
    required init(with configuration:T){
        config = configuration
    }
    //MARK: Fuctions
    func search(queryText:String) -> Observable<SearchResponse> {
        guard let searchURL = searchURL(queryText: queryText) else { return Observable.empty() }
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
        guard let videosURL = contentDetailsURL(videoId: videoId) else { return Observable.empty() }
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

//MARK: URL Generation
extension YoutubeSearchAPI {

    fileprivate func searchURL( queryText:String) -> URL? {
        let formatedQuery = queryText.replaceWhiteSpace(with: "+")
        let stringUrl = "\(config.youTubeApiUrl)search?part=snippet&q=\(formatedQuery)&type=video&maxResults=10&key=\(config.apiKey)"
        return URL(string: stringUrl)
    }

    fileprivate func contentDetailsURL(videoId:String) -> URL? {
        let contentDetailUrl = "\(config.youTubeApiUrl)videos?part=contentDetails&id=\(videoId)&fields=items(contentDetails(countryRestriction%2Cduration))&key=\(config.apiKey)"
        return URL(string: contentDetailUrl)
    }
}
