//
//  AccountsDataBase.swift
//  debtFree
//
//  Created by Nigel Ng on 28/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import Foundation

class AccountsDataBase {
    
    static var Accs: [Account] = []
    
    static func addAccount(acc: Account) {
        Accs.append(acc)
    }
}
