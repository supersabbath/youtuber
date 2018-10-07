//
//  Video.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import Foundation
import ObjectMapper


struct Video: ImmutableMappable {

    let kind:String?
    let videoId:String?
    let channelId:String?
    let title:String?
    let description:String?
    let channelTitle:String?
    let thumbNails:Thumbnails?

    init(map: Map) throws {

        kind = try? map.value("id.kind")
        videoId = try? map.value("id.videoId")
        channelId = try? map.value("snippet.channelId")
        title = try? map.value("snippet.title")
        description =  try? map.value("snippet.description")
        channelTitle = try? map.value("snippet.channelTitle")
        thumbNails = try? map.value("snippet.thumbnails.medium")
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
