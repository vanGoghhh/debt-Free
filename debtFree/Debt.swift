//
//  Debt.swift
//  debtFree
//
//  Created by Nigel Ng on 15/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import Foundation
struct Debt : Equatable {
    var debtorDebteeName: String;
    var money: String;
    var date: String;
    var notes: String;
    var oweOrOwed: String
    
    init(debtorDebteeName: String, money: String, date: String, notes: String, oweOrOwed: String) {
        self.debtorDebteeName = debtorDebteeName
        self.money = money;
        self.date = date
        self.notes = notes
        self.oweOrOwed = oweOrOwed
    }
    
    static func ==(lhs: Debt, rhs: Debt)-> Bool {
        return lhs.debtorDebteeName == rhs.debtorDebteeName
                && lhs.money == rhs.money
                && lhs.date == rhs.date
                && lhs.notes == rhs.notes
                && lhs.oweOrOwed == rhs.oweOrOwed
    }
}



