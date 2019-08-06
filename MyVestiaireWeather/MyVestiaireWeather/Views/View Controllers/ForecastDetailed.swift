//
//  ForecastDetailed.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 06/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class ForecastDetailed: UIViewController {
    
    @IBOutlet var locationName: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var forecastIcon: UIImageView!
    @IBOutlet var mainTemperature: UILabel!
    @IBOutlet var mainText: UILabel!
    @IBOutlet var descriptionText: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var hotOrCold: UILabel!
    @IBOutlet var minTemperature: UILabel!
    @IBOutlet var maxTemperature: UILabel!
    @IBOutlet var morningTemperature: UILabel!
    @IBOutlet var eveningTemperature: UILabel!
    @IBOutlet var nightTemperature: UILabel!
    
    private var forecastsViewModel: ForecastViewModel?
    private var selectedRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let rowFilled = self.selectedRow, let forecastsViewModelFilled = self.forecastsViewModel {
            self.fillUI(withViewModel: forecastsViewModelFilled, atIndex: rowFilled)
        }
    }
    
    func fillData(withForecastsViewModel forecastsViewModel: ForecastViewModel?, andWithSelectedRow selectedRow: Int?) {
        self.forecastsViewModel = forecastsViewModel
        self.selectedRow = selectedRow
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
