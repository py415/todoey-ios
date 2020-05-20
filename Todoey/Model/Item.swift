//
//  Item.swift
//  Todoey
//
//  Created by Philip Yu on 7/7/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    // MARK: - Properties
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
