//
//  File.swift
//  debtFree
//
//  Created by Nigel Ng on 3/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import Foundation

struct Account: Equatable {
    var accName: String;
    var accMoney: String;
    
    init(accName: String, accMoney: String) {
        self.accName = accName;
        self.accMoney = accMoney;
    }
    
    static func ==(lhs: Account, rhs: Account) -> Bool {
        return lhs.accName == rhs.accName && lhs.accMoney == rhs.accMoney
    }
}
