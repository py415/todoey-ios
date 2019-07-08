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
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
       
}
