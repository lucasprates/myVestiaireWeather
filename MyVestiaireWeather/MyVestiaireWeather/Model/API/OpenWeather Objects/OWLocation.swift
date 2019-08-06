//
//  OWLocation.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 04/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class OWLocation: NSObject {
    
    var id: Int?                //"id"
    var city: String?           //"name"
    var country: String?        //"country"
    var population: Int?        //"population"
    var timezone: Int?          //"timezone"
    var latitude: Double?       //"coord" -> "lon"
    var longitude: Double?      //"coord" -> "lat"
    
    init(withDataDictionary dataDict: [String: Any]?) {
        self.id = dataDict?["id"] as? Int
        self.city = dataDict?["name"] as? String
        self.country = dataDict?["country"] as? String
        self.population = dataDict?["population"] as? Int
        self.timezone = dataDict?["timezone"] as? Int
        self.latitude = (dataDict?["coord"] as? [String: Any])?["lon"] as? Double
        self.longitude = (dataDict?["coord"] as? [String: Any])?["lat"] as? Double
    }
    
}
