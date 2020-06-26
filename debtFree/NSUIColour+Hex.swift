//
//  NSUIColour+Hex.swift
//  debtFree
//
//  Created by Nigel Ng on 25/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import Foundation
import Charts

extension NSUIColor {
    convenience init (red: Int, blue: Int, green: Int) {
        assert(red >= 0 && red <= 255, "Invalid Red Component")
        assert(blue >= 0 && blue <= 255, "Invalid Blue Component")
        assert(green >= 0 && green <= 255, "Invalid Green Component")
    
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(blue) / 255.0, blue: CGFloat(green) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xff,
            blue: hex & 0xff, green: (hex >> 8) & 0xff)
    }
}
