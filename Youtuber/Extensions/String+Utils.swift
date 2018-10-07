//
//  String+Utils.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/6/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import Foundation

extension String {
    func replaceWhiteSpace(with string:String) -> String {
        return self.replacingOccurrences(of: " ", with: string)
    }
}
