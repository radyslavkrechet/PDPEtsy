//
//  DatabaseManager.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/7/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Work With Objects
    
    func delete(objects: [Object]) {
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    // MARK: - Work With Categories
    
    func replace(categories: [Category]) {
        let existingCategories = self.fetchCategories()
        let categoriesToAdding = categories.filter { !existingCategories.contains($0) }
        let categoriesToDeleting = existingCategories.filter { !categories.contains($0) }

        try! realm.write {
            realm.add(categoriesToAdding)
            realm.delete(categoriesToDeleting)
        }
    }
    
    func fetchCategories() -> [Category] {
        return Array(realm.objects(Category.self))
    }
    
    // MARK: - Work With Products
    
    func add(products: [Product]) {
        let objects = products.map { Product(value: $0) }
        
        try! realm.write {
            realm.add(objects)
        }
    }
    
    func fetchProducts() -> [Product] {
        return Array(realm.objects(Product.self))
    }
    
    func isAddedProduct(_ product: Product) -> Bool {
        let products = realm.objects(Product.self).filter("id == \(product.id)")
        return !products.isEmpty
    }
}
