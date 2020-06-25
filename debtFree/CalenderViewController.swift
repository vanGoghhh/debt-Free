//  CalenderViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 25/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource{

    @IBOutlet var calender: FSCalendar!
    
    var originalDate : String?
    var editedDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calender.delegate = self
        calender.dataSource = self
        // Do any additional setup after loading the view.
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
