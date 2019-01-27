//
//  NetworkRouter.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/5/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Alamofire

enum NetworkRouter: URLRequestConvertible {
    case loadCategories(parameters: Parameters)
    case loadProducts(parameters: Parameters)
    
    fileprivate static let baseUrlString = "https://openapi.etsy.com/v2"
    fileprivate static let apiKey = "api_key"
    fileprivate static let apiValue = "4rgsv7etixthkxch0eo8r5b5"
    
    fileprivate var method: HTTPMethod {
        switch self {
        case .loadCategories, .loadProducts:
            return .get
        }
    }
    
    fileprivate var path: String {
        switch self {
        case .loadCategories:
            return "/taxonomy/categories"
        case .loadProducts:
            return "/listings/active"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkRouter.baseUrlString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        var parameters: Parameters = {
            switch self {
            case .loadCategories(let parameters):
                return parameters
            case .loadProducts(let parameters):
                return parameters
            }
        }()
        
        parameters[NetworkRouter.apiKey] = NetworkRouter.apiValue
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
