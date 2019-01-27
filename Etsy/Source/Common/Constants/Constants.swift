//
//  Constants.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/7/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

struct Constants {
    struct CellIdentifiers {
        static let productCell = "ProductCell"
    }
    
    struct SegueIdentifiers {
        static let toProducts = "ToProducts"
        static let toProduct = "ToProduct"
    }

    struct NetworkKeys {
        static let idOfCategory = "category_id"
        static let nameOfCategory = "long_name"
        static let idOfProduct = "listing_id"
        static let imageOfProduct = "MainImage"
        static let thumbnailImageOfProduct = "MainImage.url_170x135"
        static let originalImageOfProduct = "MainImage.url_570xN"
        static let titleOfProduct = "title"
        static let priceOfProduct = "price"
        static let detailOfProduct = "description"
    }
}
