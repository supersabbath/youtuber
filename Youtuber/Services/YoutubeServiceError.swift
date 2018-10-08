//
//  YoutubeServiceError.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/7/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//
import Foundation

enum YoutubeServiceError: Error {
    case offline
    case queryLimitReached
    case badRequest
    case networkError
}
