//
//  DebtsInsightViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 25/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
import Charts

class DebtsInsightViewController: UIViewController {
    
    
    @IBOutlet var pieChart: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        setUpPieChart()
        updateChart()
        //self.view.addSubview(pieChart)
    }
    
    func setUpPieChart() {
        pieChart?.drawHoleEnabled = false
        pieChart?.rotationAngle = 0
        pieChart?.rotationEnabled = false
        pieChart?.isUserInteractionEnabled = false
       
    }
//    func configChart() {
//        var entry = [PieChartDataEntry]()
//        var debtOwe = 0
//
//        for debt in debtsData.debtsOwe {
//            debtOwe += Int(debt.money)!
//        }
//        var debtOweTo = 0
//
//        for debt in debtsData.debtsOwedTo {
//            debtOweTo += Int(debt.money)!
//        }
//        print(debtOwe)
//        print(debtOweTo)
//        entry.append(PieChartDataEntry(value: Double(debtOwe)))
//        entry.append(PieChartDataEntry(value: Double(debtOweTo)))
//
//        let dataSet = PieChartDataSet(entries: entry, label: "")
//        let chartData = PieChartData(dataSet: dataSet)
//        dataSet.colors = [UIColor.systemRed, UIColor.systemBlue]
//        pieChart.data = chartData
//    }
    func updateChart() {
        let moneyIn =  PieChartDataEntry(value: Double(debtsData.recalculateDebtOwe()))
        let moneyOut =  PieChartDataEntry(value: Double(debtsData.recalculateDebtOwedTo()))
        var values = [PieChartDataEntry]()

      
        moneyIn.label = "Debts I owe"
        moneyOut.label = "Debts people owe me"
        values.append(moneyIn)
        values.append(moneyOut)
        print(moneyIn.value)
        let chartDataSet = PieChartDataSet(entries: values, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        let colour1 = UIColor.white
        let colour2 = UIColor.blue
        chartDataSet.colors = [colour1, colour2]
        pieChart?.data = chartData
        pieChart?.setNeedsDisplay()
    }


}
