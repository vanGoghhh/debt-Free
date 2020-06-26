//
//  AppTabBarController.swift
//  debtFree
//
//  Created by Nigel Ng on 25/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let firstVC = viewController as? DebtsInsightViewController  {
            //firstVC.updateChart()
        }
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
