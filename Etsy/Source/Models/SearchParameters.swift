//
//  SearchingParameters.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/5/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

struct SearchParameters {
    static let pageLimit = 25
    
    var keyword: String?
    var category: String?
    
    var isFirstPage: Bool {
        return page == 1
    }
    var isCanLoadMoreProducts: Bool {
        return page >= 1
    }
    
    private(set) var page: Int = 1
    
    // MARK: - Work With Page
    
    mutating func firstPage() {
        page = 1
    }
    
    mutating func nextPage() {
        page += 1
    }
    
    mutating func canLoadMoreProducts(_ can: Bool) {
        if !can {
            page = 0
        }
    }
}
