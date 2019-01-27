//
//  Category.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/6/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import RealmSwift
import ObjectMapper

class Category: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Equatable
    
    override func isEqual(_ object: Any?) -> Bool {
        var isEqual = false
        
        if let category = object as? Category {
            isEqual = id == category.id
        }
        
        return isEqual
    }
    
    // MARK: - Mappable
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map[Constants.NetworkKeys.idOfCategory]
        name <- map[Constants.NetworkKeys.nameOfCategory]
    }
}
