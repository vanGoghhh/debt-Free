//
//  AddDueDateViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 26/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
import FSCalendar

class AddDueDateViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet var calendar: FSCalendar!
    
    var ogDate: String?
    var newDueDate: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        newDueDate = formatter.string(from: date)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.date(from: ogDate!)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addDueDate") {
            if let destination = segue.destination as? AddDebtTableViewController {
                destination.newDueDate = self.newDueDate
            }
        }
    }
     
    @IBAction func saveDueDate(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addDueDate", sender: self)
    }
    
}
