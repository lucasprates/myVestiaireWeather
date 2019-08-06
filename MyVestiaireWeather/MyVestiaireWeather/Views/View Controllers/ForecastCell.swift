//
//  ForecastCell.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 06/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell { //re-usable identifier: "forecastUnitCell"
    
    @IBOutlet var locationName: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var mainTemperature: UILabel!
    
    @IBOutlet var detail: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func forecastDetailTouched(_ sender: UIButton) {
        
    }
}
