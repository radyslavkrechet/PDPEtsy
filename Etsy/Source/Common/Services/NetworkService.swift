//
//  NetworkService.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/5/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Alamofire
import ObjectMapper

typealias NetworkCompletion = (_ response: Any?, _ error: Error?) -> Void

struct NetworkService {
    private static let fieldsKey = "fields"
    private static let includesKey = "includes"
    private static let keywordsKey = "keywords"
    private static let categoryKey = "category"
    private static let pageKey = "page"
    private static let resultsKey = "results"
    
    // MARK: - Work With Categories
    
    static func loadCategories(completion: @escaping NetworkCompletion) {
        let parameters = [fieldsKey: "\(Constants.NetworkKeys.idOfCategory),\(Constants.NetworkKeys.nameOfCategory)"]
        
        Alamofire.request(NetworkRouter.loadCategories(parameters: parameters)).responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            } else if let value = response.result.value as? [String: Any],
                let json = value[resultsKey] as? [[String: Any]] {

                let categories = Mapper<Category>().mapArray(JSONArray: json)
                completion(categories, nil)
            }
        }
    }
    
    // MARK: - Work With Products
    
    static func loadProducts(withParameters searchParameters: SearchParameters,
                             completion: @escaping NetworkCompletion) {
        
        var fieldsValue = "\(Constants.NetworkKeys.idOfProduct),\(Constants.NetworkKeys.titleOfProduct),"
        fieldsValue += "\(Constants.NetworkKeys.priceOfProduct),\(Constants.NetworkKeys.detailOfProduct)"
        
        var parameters: [String: Any] = [pageKey: searchParameters.page,
                                         fieldsKey: fieldsValue,
                                         includesKey: Constants.NetworkKeys.imageOfProduct]
        
        if let keyword = searchParameters.keyword {
            parameters[keywordsKey] = keyword
        }
        
        if let category = searchParameters.category {
            parameters[categoryKey] = category
        }
        
        Alamofire.request(NetworkRouter.loadProducts(parameters: parameters)).responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            } else if let value = response.result.value as? [String: Any],
                let json = value[resultsKey] as? [[String: Any]] {

                let products = Mapper<Product>().mapArray(JSONArray: json)
                completion(products, nil)
            }
        }
    }
}
