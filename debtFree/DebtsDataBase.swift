//
//  DebtsDataBase.swift
//  
//
//  Created by Nigel Ng on 25/6/20.
//

import Foundation

class debtsData {
    static var debtsOwe: [Debt] = []
    static var debtsOwedTo: [Debt] = []
    
    static func addDebtOwe(debt: Debt) {
        debtsOwe.append(debt)
    }
    
    static func addDebtOwedTo(debt: Debt) {
        debtsOwedTo.append(debt)
    }
    
    static func recalculateDebtOwe() -> Int {
        var moneyOwed = 0
        for debt in debtsOwe {
            moneyOwed += Int(debt.money)!
        }
        return moneyOwed
    }
    
    static func recalculateDebtOwedTo() -> Int {
        var moneyOwedTo = 0
        for debt in debtsOwedTo {
            moneyOwedTo += Int(debt.money)!
        }
        return moneyOwedTo
    }
    
    
    
}
