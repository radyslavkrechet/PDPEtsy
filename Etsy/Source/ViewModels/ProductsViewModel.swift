//
//  ProductsViewModel.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/7/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

class ProductsViewModel {
    var productsDidFetch: (() -> Void)?
    var productsDidLoad: ((_ insertingIndexPaths: [IndexPath]) -> Void)?
    var nextProductsDidLoad: ((_ insertingIndexPaths: [IndexPath]) -> Void)?
    var productsDidReload: ((_ insertingIndexPaths: [IndexPath], _ deletingIndexPaths: [IndexPath]) -> Void)?
    var productsDidDelete: ((_ deletingIndexPaths: [IndexPath]) -> Void)?
    
    var selectedProduct: Any {
        let index = indexsOfSelectedProducts.first!
        indexsOfSelectedProducts.removeFirst()
        return objectsOfProduct[index]
    }
    var numberOfSelectedProducts: Int {
        return indexsOfSelectedProducts.count
    }
    
    private(set) var products = [(imageUrlString: String, title: String)]()
    
    private var parameters = SearchParameters()
    private var operation = ProductsOperationType.load
    private var indexsOfSelectedProducts = [Int]()
    
    private var objectsOfProduct = [Product]() {
        didSet {
            products = objectsOfProduct.map { ($0.thumbnailImageUrlString, $0.title) }
        }
    }
    
    private enum ProductsOperationType: Int {
        case load, loadNext, reload
    }
    
    // MARK: - Work With Parameters
    
    func receive(_ parameters: Any) {
        if let parameters = parameters as? SearchParameters {
            self.parameters = parameters
        }
    }
    
    // MARK: - Work With Products
    
    private func indexPaths(ofObjects objects: [Product], inArray array: [Product]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for object in objects {
            if let row = array.index(of: object) {
                let indexPath = IndexPath(row: row, section: 0)
                indexPaths.append(indexPath)
            }
        }
        
        return indexPaths
    }
    
    func fetchProducts() {
        objectsOfProduct = DatabaseManager.shared.fetchProducts()
        productsDidFetch?()
    }
    
    func loadProducts() {
        NetworkManager.shared.loadProducts(withParameters: parameters) { [unowned self] (response, error) in
            DispatchQueue.main.async {
                if let products = response as? [Product] {
                    self.parameters.canLoadMoreProducts(products.count == SearchParameters.pageLimit)
                    
                    var deletingIndexPaths: [IndexPath]!
                    
                    if self.parameters.isFirstPage == true {
                        deletingIndexPaths = self.indexPaths(ofObjects: self.objectsOfProduct,
                                                             inArray: self.objectsOfProduct)
                        
                        self.objectsOfProduct = products
                    } else {
                        self.objectsOfProduct += products
                    }
                    
                    let insertingIndexPaths = self.indexPaths(ofObjects: products, inArray: self.objectsOfProduct)
                    
                    if self.operation == .loadNext {
                        self.nextProductsDidLoad?(insertingIndexPaths)
                    } else if self.operation == .reload {
                        self.productsDidReload?(insertingIndexPaths, deletingIndexPaths)
                    } else {
                        self.productsDidLoad?(insertingIndexPaths)
                    }
                    
                    self.operation = .load
                }
            }
        }
    }
    
    func loadNextProductsIfCan() {
        guard parameters.isCanLoadMoreProducts else {
            return
        }
        
        parameters.nextPage()
        operation = .loadNext
        loadProducts()
    }
    
    func reloadProducts() {
        parameters.firstPage()
        operation = .reload
        loadProducts()
    }
    
    func selectProduct(atIndex index: Int) {
        indexsOfSelectedProducts.append(index)
    }
    
    func deselectProduct(atIndex index: Int) {
        if let indexOfValue = indexsOfSelectedProducts.index(of: index) {
            indexsOfSelectedProducts.remove(at: indexOfValue)
        }
    }
    
    func deselectAllProducts() {
        indexsOfSelectedProducts.removeAll()
    }
    
    func isSelectedProduct(atIndex index: Int) -> Bool {
        guard !indexsOfSelectedProducts.isEmpty else {
            return false
        }
        
        return indexsOfSelectedProducts.contains(index)
    }
    
    func deleteSelectedProducts() {
        var objects = [Product]()
        for index in indexsOfSelectedProducts {
            objects.append(objectsOfProduct[index])
        }
        
        let deletingIndexPaths = self.indexPaths(ofObjects: objects, inArray: objectsOfProduct)
        objectsOfProduct = objectsOfProduct.filter { !objects.contains($0) }
        
        deselectAllProducts()
        
        DatabaseManager.shared.delete(objects: objects)
        
        productsDidDelete?(deletingIndexPaths)
    }
}
