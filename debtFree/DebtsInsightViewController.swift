//
//  DebtsInsightViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 25/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
import Charts

class DebtsInsightViewController: DebtsViewController {
    
    @IBOutlet var pieChart : PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()      
        setUpPieChart()
        updateChart()
        //pieChart.reloadInputViews()
    }
    
    func setUpPieChart() {
        pieChart.drawHoleEnabled = false
        pieChart.rotationAngle = 0
        pieChart.rotationEnabled = false
        pieChart.isUserInteractionEnabled = false
       
    }
    
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
        let colour1 = UIColor.red
        let colour2 = UIColor.blue
        chartDataSet.colors = [colour1, colour2]
        pieChart.data = chartData
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
