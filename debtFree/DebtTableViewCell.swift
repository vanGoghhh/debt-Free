//
//  DebtTableViewCell.swift
//  debtFree
//
//  Created by Nigel Ng on 15/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit

class DebtTableViewCell: UITableViewCell {

    @IBOutlet var debtorDebteeName: UILabel!
 
    @IBOutlet var dueDate: UILabel!
    
    @IBOutlet var amountOwed: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with debt: Debt) {
        debtorDebteeName.text = debt.debtorDebteeName
        dueDate.text = debt.date
        amountOwed.text = "$" + debt.money
    }
    

}
