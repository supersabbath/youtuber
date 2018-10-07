//
//  ContentDetails.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import Foundation
import ObjectMapper

struct ContentDetails:ImmutableMappable {
    
    let duration:String?

    init(map: Map) throws {
        duration = try? map.value("contentDetails.duration")
    }

    var readableDuration:String {
        guard let d = duration?.lowercased() else {  return "" }
        return "Duration:"  + String(d.dropFirst(2)).replacingOccurrences(of: "m", with: "min ")
    }
}
