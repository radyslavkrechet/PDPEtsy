//
//  AlertService.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/11/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

struct AlertService {
    static func deleteAlert(withNumberOfProducts numberOfProducts: Int,
                            deleteActionHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        
        var deleteTitle = ""
        let delete = NSLocalizedString("Delete", comment: "")
        
        if numberOfProducts > 1 {
            let products = NSLocalizedString("Products", comment: "")
            deleteTitle = "\(delete) \(numberOfProducts) \(products)"
        } else {
            let product = NSLocalizedString("Product", comment: "")
            deleteTitle = "\(delete) \(product)"
        }
        
        let deleteAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: deleteTitle, style: .destructive, handler: deleteActionHandler)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        return deleteAlert
    }
}
