//
//  Item.swift
//  Todoey
//
//  Created by Katherine Choi on 5/17/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
