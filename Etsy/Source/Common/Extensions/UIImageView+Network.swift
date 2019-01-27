//
//  UIImageView+Network.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/10/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    func setImage(withUrlString urlString: String) {
        image = nil
        
        if let url = URL(string: urlString) {
            af_setImage(withURL: url)
        }
    }
}
