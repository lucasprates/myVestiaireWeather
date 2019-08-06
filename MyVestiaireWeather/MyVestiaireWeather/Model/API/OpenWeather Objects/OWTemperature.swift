//
//  OWTemperature.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 04/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class OWTemperature: NSObject {
    
    var day: Double?
    var minimum: Double?
    var maximum: Double?
    var morning: Double?
    var evening: Double?
    var night: Double?
    
    init(withDataDictionary dataDict: [String: Any]?) {
        self.day = dataDict?["day"] as? Double
        self.minimum = dataDict?["min"] as? Double
        self.maximum = dataDict?["max"] as? Double
        self.morning = dataDict?["morn"] as? Double
        self.evening = dataDict?["eve"] as? Double
        self.night = dataDict?["night"] as? Double
    }
    
}
