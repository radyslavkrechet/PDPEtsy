//
//  NetworkManager.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/6/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Alamofire
import AlamofireNetworkActivityIndicator

class NetworkManager {
    static let shared = NetworkManager()
    
    private var reachabilityManager: NetworkReachabilityManager = NetworkReachabilityManager()!
    private var isReachable: Bool = true
    
    // MARK: - Lifecycle
    
    private init() {
        self.configureReachabilityManager()
        self.configureActivityIndicatorManager()
    }
    
    // MARK: - Configuration
    
    private func configureReachabilityManager() {
        isReachable = reachabilityManager.isReachable
        
        reachabilityManager.listener = { [unowned self] status in
            self.isReachable = (status == .reachable(.ethernetOrWiFi) || status == .reachable(.wwan))
        }
        
        reachabilityManager.startListening()
    }
    
    private func configureActivityIndicatorManager() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.0
        NetworkActivityIndicatorManager.shared.completionDelay = 0.0
    }
    
    // MARK: - Work With Categories
    
    func loadCategories(completion: @escaping NetworkCompletion) {
        guard isReachable else {
            completion(nil, nil)
            return
        }
        
        NetworkService.loadCategories(completion: completion)
    }
    
    // MARK: - Work With Products
    
    func loadProducts(withParameters parameters: SearchParameters, completion: @escaping NetworkCompletion) {
        guard isReachable else {
            completion(nil, nil)
            return
        }
        
        NetworkService.loadProducts(withParameters: parameters, completion: completion)
    }
}
