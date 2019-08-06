//
//  OWForecast.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 04/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class OWForecast: NSObject {
    
    var date: Date?
    var speed: Double?
    var degree: Double?
    var humidity: Double?
    var pressure: Double?
    var clouds: Int?
    
    var mainText: String?
    var descriptionText: String?
    
    var temperatures: OWTemperature?
    var location: OWLocation?
    
    var iconName: String?
    
    init(withDataDictionary dataDict: [String: Any]?, forLocation location: OWLocation?) {
        self.location = location
        
        if let dtFilled = dataDict?["dt"] as? Int {
            self.date = Date(timeIntervalSince1970: Double(dtFilled))
        }
        self.speed = dataDict?["speed"] as? Double
        self.degree = dataDict?["deg"] as? Double
        self.humidity = dataDict?["humidity"] as? Double
        self.pressure = dataDict?["pressure"] as? Double
        self.clouds = dataDict?["clouds"] as? Int
    
        if let weatherDescription = dataDict?["weather"] as? [[String : Any]] {
            if weatherDescription.count > 0 {
                self.mainText = weatherDescription[0]["main"] as? String
                self.descriptionText = weatherDescription[0]["description"] as? String
                self.iconName = weatherDescription[0]["icon"] as? String
            }
        }
        
        self.temperatures = OWTemperature(withDataDictionary: dataDict?["temp"] as? [String : Any])
    }
}
