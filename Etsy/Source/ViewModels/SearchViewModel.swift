//
//  SearchViewModel.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/7/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

class SearchViewModel {
    var categoriesDidChange: (() -> Void)? {
        didSet {
            fetchCategories()
            loadCategories()
        }
    }
    var parameters: Any {
        return objectOfParameters
    }
    
    private(set) var categories = [String]() {
        didSet {
            categoriesDidChange?()
        }
    }
    
    private let allCategories = NSLocalizedString("AllCategories", comment: "")
    
    private var objectsOfCategory = [Category]() {
        didSet {
            var names = objectsOfCategory.map { $0.name }
            names.insert(allCategories, at: 0)
            categories = names
        }
    }
    
    private var objectOfParameters = SearchParameters()
    
    // MARK: - Work With Categories
    
    private func fetchCategories() {
        objectsOfCategory = DatabaseManager.shared.fetchCategories()
    }
    
    private func loadCategories() {
        NetworkManager.shared.loadCategories { [unowned self] (response, _) in
            DispatchQueue.main.async {
                if let categories = response as? [Category] {
                    DatabaseManager.shared.replace(categories: categories)
                    self.objectsOfCategory = categories
                }
            }
        }
    }
    
    // MARK: - Work With Parameters
    
    func setKeyword(_ keyword: String?) {
        objectOfParameters.keyword = keyword
    }
    
    func selectCategory(atIndex index: Int) {
        objectOfParameters.category = categories[index]
    }
}
