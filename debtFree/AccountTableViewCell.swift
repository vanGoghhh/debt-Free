//
//  AccountTableViewCell.swift
//  debtFree
//
//  Created by Nigel Ng on 6/7/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet var accName: UILabel!
    @IBOutlet var accMoney: UILabel!
    @IBOutlet var accNameLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellView: UIView!
    @IBOutlet var accMoneyLabel: UILabel!
    
     var accounts = AccountsDataBase.Accs
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.cellImage.image = UIImage(named: "dollar-sign-button")
        self.cellView.backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 75/255, alpha: 1)
        self.accMoney.textColor = UIColor(red: 0/255, green: 153/255, blue: 76/255, alpha: 1)
        self.accName.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.accNameLabel.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        self.accMoneyLabel.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        self.cellView.layer.borderWidth =  7
        self.cellView.layer.cornerRadius = 20
        self.cellView.layer.borderColor =  UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1).cgColor
        self.contentView.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
