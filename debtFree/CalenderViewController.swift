//  CalenderViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 25/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
import FSCalendar
import PMSuperButton

class CalenderViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource{

    @IBOutlet var calender: FSCalendar!
    @IBOutlet var saveDate: PMSuperButton!
    
    var originalDate : String?
    var editedDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calender.delegate = self
        calender.dataSource = self
        self.view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.saveDate.gradientStartColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1)
        self.saveDate.gradientEndColor = UIColor(red: 142/255, green: 14/255, blue: 155/255, alpha: 1)
        self.calender.backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 75/255, alpha: 1)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        editedDate = formatter.string(from: date)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        print(originalDate)
        return dateFormatter.date(from: originalDate!)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editedDate") {
            if let destination = segue.destination as? IndividualDebtViewController {
                destination.newDate = self.editedDate
                
            }
        }
    }
    
    @IBAction func saveNewDate(_ sender: Any) {
        performSegue(withIdentifier: "editedDate", sender: self)
    }
    

}
