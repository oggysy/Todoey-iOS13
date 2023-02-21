//
//  Category.swift
//  Todoey
//
//  Created by 小木曽佑介 on 2023/02/19.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
