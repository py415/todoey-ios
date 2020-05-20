//
//  Category.swift
//  Todoey
//
//  Created by Philip Yu on 7/7/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    // MARK: - Properties
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
       
}
