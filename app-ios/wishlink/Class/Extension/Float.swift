//
//  Float.swift
//  wishlink
//
//  Created by Andy Chen on 10/8/15.
//  Copyright (c) 2015 edonesoft. All rights reserved.
//

import Foundation

extension Float {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}