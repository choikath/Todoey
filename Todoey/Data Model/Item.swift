//
//  Item.swift
//  Todoey
//
//  Created by Katherine Choi on 4/26/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
