//
//  Product.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/6/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import RealmSwift
import ObjectMapper

class Product: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var thumbnailImageUrlString = ""
    @objc dynamic var originalImageUrlString = ""
    @objc dynamic var title = ""
    @objc dynamic var price = ""
    @objc dynamic var detail = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Mappable
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map[Constants.NetworkKeys.idOfProduct]
        thumbnailImageUrlString <- map[Constants.NetworkKeys.thumbnailImageOfProduct]
        originalImageUrlString <- map[Constants.NetworkKeys.thumbnailImageOfProduct]
        title <- map[Constants.NetworkKeys.titleOfProduct]
        price <- map[Constants.NetworkKeys.priceOfProduct]
        detail <- map[Constants.NetworkKeys.detailOfProduct]
    }
}
