//
//  Config.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import Foundation

protocol ApiConfiguration {
    var youTubeApiUrl:String { get }
    var apiKey:String { get }
}

struct Config: ApiConfiguration {
    let youTubeApiUrl = "https://www.googleapis.com/youtube/v3/"
    let apiKey = "AIzaSyCjy9QR_qrVUh3CVb5j1CKcruLXjQ2gnoU"
}
