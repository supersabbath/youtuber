//
//  Video.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

struct Video: ImmutableMappable {

    let kind:String?
    let videoId:String?
    let channelId:String?
    let title:String?
    let description:String?
    let channelTitle:String?
    let thumbNails:Thumbnails?
    let publishedAt:String?
    let durationVariable = Variable<String>("")
    let disposeBag = DisposeBag()

    init(map: Map) throws {

        kind = try? map.value("id.kind")
        videoId = try? map.value("id.videoId")
        channelId = try? map.value("snippet.channelId")
        title = try? map.value("snippet.title")
        description =  try? map.value("snippet.description")
        channelTitle = try? map.value("snippet.channelTitle")
        thumbNails = try? map.value("snippet.thumbnails.medium")
        publishedAt = try? map.value("snippet.publishedAt")
    }

    var publishedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = publishedAt else { return "" }
        guard let yourDate = formatter.date(from: String(date.dropLast(5))) else { return "" }
        formatter.dateFormat = "dd-MMM-yyyy"
       return formatter.string(from: yourDate)
    }

    func getDuration(use youtubeClient:YoutubeSearchAPI)  {
        guard let videoId = self.videoId else {
            return
        }
        guard durationVariable.value.isEmpty else { return }
        youtubeClient.fetchContentDetails(for: videoId).subscribe(onNext: { (contentDetail) in
            guard let duration  = contentDetail?.readableDuration else { return }
            self.durationVariable.value = duration
        }).disposed(by: disposeBag)
    }

}

public struct Thumbnails: ImmutableMappable {

    let url:String?
    let width:UInt
    let height:UInt

    public init(map: Map) throws {
        url = try? map.value("url")
        height = try map.value("height")
        width = try map.value("width")
    }

    var imageUrl : URL? {
        guard url != nil else { return nil }
        return URL(string: url!)
    }
}
