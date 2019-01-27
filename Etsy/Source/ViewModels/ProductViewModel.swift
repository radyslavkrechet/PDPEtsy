//
//  ProductViewModel.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/7/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

class ProductViewModel {
    var product: (imageUrlString: String, name: String, price: String, detail: String) {
        let imageUrlString = objectOfProduct.originalImageUrlString
        let name = objectOfProduct.title
        let price = "$\(objectOfProduct.price)"
        let detail = objectOfProduct.detail
        return (imageUrlString, name, price, detail)
    }
    var isAddedProduct: Bool {
        return DatabaseManager.shared.isAddedProduct(objectOfProduct)
    }
    
    private var objectOfProduct: Product!
    
    // MARK: - Work With Product
    
    func receive(_ product: Any) {
        if let product = product as? Product {
            objectOfProduct = product
        }
    }
    
    func addProduct() {
        DatabaseManager.shared.add(products: [objectOfProduct])
    }
    
    func deleteProduct() {
        DatabaseManager.shared.delete(objects: [objectOfProduct])
    }
}
