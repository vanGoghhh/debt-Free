//
//  File.swift
//  debtFree
//
//  Created by Nigel Ng on 3/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import Foundation

struct Account {
    var accName: String;
    var accMoney: String;
    
    init(accName: String, accMoney: String) {
        self.accName = accName;
        self.accMoney = accMoney;
    }
}
