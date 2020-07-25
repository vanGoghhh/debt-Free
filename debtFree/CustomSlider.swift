//
//  CustomSlider.swift
//  debtFree
//
//  Created by Nigel Ng on 16/7/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
@IBDesignable

class CustomSlider: UISlider {
   
    @IBInspectable var moneyImage: UIImage? {
        didSet {
            setThumbImage(moneyImage, for: .normal)
        }
    }
}



