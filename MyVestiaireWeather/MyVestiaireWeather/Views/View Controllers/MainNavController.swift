//
//  MainViewController.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 03/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class MainNavController: UINavigationController {
    
    private var forecastVM: ForecastViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

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

extension ForecastViewModel {
    
    func fillUI(forTableViewController tableViewController: ForecastsTable) {
        
    }
}
