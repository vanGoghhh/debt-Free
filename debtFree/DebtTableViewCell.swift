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
    
    @IBOutlet var cellView: UIView!
    
    @IBOutlet var amountOwed: UILabel!
    
    @IBOutlet var cellImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
//        let mScreenSize = UIScreen.main.bounds
//        let mSeparatorHeight = CGFloat(5.0) // Change height of speatator as you want
//        let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
//        mAddSeparator.backgroundColor = UIColor.red // Change backgroundColor of separator
//        self.addSubview(mAddSeparator)
        //var color  = generateRandomPastelColor(withMixedColor: UIColor.white)
       
        //self.cellView.backgroundColor = color
        self.cellImage.image = UIImage(named: "dollar-sign-button")
        self.cellView.backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 75/255, alpha: 1)
        self.cellView.layer.cornerRadius = 20
        self.amountOwed.textColor = UIColor(red: 0/255, green: 153/255, blue: 76/255, alpha: 1)
        self.debtorDebteeName.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        self.dueDate.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        self.cellView.layer.borderWidth =  7
        self.cellView.layer.borderColor =  UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1).cgColor
        self.contentView.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        //super.layoutSubviews()
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
    }
    
    func update(with debt: Debt) {
        debtorDebteeName.text = debt.debtorDebteeName
        dueDate.text = debt.date
        amountOwed.text = "$" + debt.money
    }
    
    func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
        // Randomly generate number in closure
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256 ) / 256
        }
            
        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()
            
        // Mix the color
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
            
            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }
            
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
