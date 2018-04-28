//
//  Util.swift
//  AbsoluteDate
//
//  Created by Gregory Higley on 4/28/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import Foundation

func hash(_ hashables: AnyHashable?...) -> Int {
    // djb2 hash algorithm: http://www.cse.yorku.ca/~oz/hash.html
    // &+ operator handles Int overflow
    return hashables.compactMap{ $0 }.reduce(5381) { (result, hashable) in ((result << 5) &+ result) &+ hashable.hashValue }
}
