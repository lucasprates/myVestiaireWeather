//
//  ForecastViewModel.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 03/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit
import CoreData

class ForecastViewModel: NSObject {
    
    var forecasts: [Forecast]?
    private var forecastDataDidUpdate: (() -> Void)?
    
    var forecastsCount: Int { get {
        return forecasts?.filter({ $0.date?.timeIntervalSince(Calendar.current.startOfDay(for: Date())) ?? 0 > 0 }).count ?? 0 }
    }
    
    init(withForecastDataUpdateReturnBlock newUpdateReturnBlock: (() -> Void)?) {
        //get forecasts from CoreData
        self.forecasts = CoreDataController.shared().getObjects(ofEntity: "Forecast", withPredicate: nil) as? [Forecast]
        
        //filter past forecasts
        self.forecasts?.removeAll(where: { $0.date?.timeIntervalSince(Calendar.current.startOfDay(for: Date())) ?? 0 < 0 })
        
        self.forecastDataDidUpdate = newUpdateReturnBlock
        
        super.init()
        
        //start OpenWeather's API
        OpenWeatherAPI.shared().start(withReturnBlock: self.newDataArrivedReturnBlock())
    }
    
    //Data arrived from Model "downer" layer of OpenWeather's API
    func newDataArrivedReturnBlock() ->  ((_ : [OWForecast]?) -> Void)? {
        return { (_ newForecasts: [OWForecast]?) in
            //remove past forecasts
            let newFutureForecasts = newForecasts?.filter({ $0.date?.timeIntervalSince(Calendar.current.startOfDay(for: Date())) ?? 0 > 0 }) ?? []
            
            //send the new forecast received to the Local CoreData Database
            CoreDataController.shared().newForecastsArrived(fromOpenWeatherForecast: newFutureForecasts)
            
            self.forecasts = CoreDataController.shared().getObjects(ofEntity: "Forecast", withPredicate: nil) as? [Forecast]
            
            self.forecasts?.sort(by: { (first: Forecast, second: Forecast) -> Bool in
                return (first.date?.timeIntervalSince1970 ?? 0) <= (second.date?.timeIntervalSince1970 ?? 0)
            })
            
            //tell UI, and prepare-and-send info, that new forecast arrived
            self.forecastDataDidUpdate?()
        }
    }
}

//Open Weather API -> Core Data registry converter - CoreDataController part
extension CoreDataController {
    
    func newForecastsArrived(fromOpenWeatherForecast newOWForecasts: [OWForecast]) {
        //remove all coreData records
        self.removeAllData()
        
        //get new forecast
        guard let contextDB = self.getContextDB() else { return }
        
        for newOWForecaseUnit in newOWForecasts {
            let newDbForecast = Forecast(context: contextDB)
            
            //try to fech existing location
            let dbLocation: Location? = self.getObjects(ofEntity: "Location", withPredicate: "id == \(newOWForecaseUnit.location?.id ?? -1)") as? Location
            
            //now fill new OWForecast Info into DB Object
            newOWForecaseUnit.fillInfo(intoDbObject: newDbForecast, withContext: contextDB, intoLocation: dbLocation)
        }
        
        //save new info into db context right away
        self.saveCoreDataDB()
    }
}

//Forecast Table View each Cells' View Controller UI Filling - ForecastViewModel
extension ForecastCell {
    
    func fillCellUI(withViewModel viewModel: ForecastViewModel?, atIndex index: Int) {
        //if there is an actual forecast for this index, show its simple cell info
        if ((viewModel?.forecasts?.count ?? -1) > index) {
            guard let cellInfo = viewModel?.forecasts?[index] else { return }
            let locationName = cellInfo.location?.name ?? ""
            let locationCountry = (cellInfo.location?.country ?? "").uppercased()
            self.locationName.text = locationName + ", " + locationCountry
            self.mainTemperature.text = "\(cellInfo.temperature?.day ?? 0)ºC"
            
            let dateFormatterConvert = DateFormatter()
            dateFormatterConvert.dateFormat = "dd/MM/yyyy"
            if let dateFilled = cellInfo.date {
                self.date.text = dateFormatterConvert.string(from: dateFilled as Date)
            }
        }
    }
}

//Forecast Detailed View Controller UI Filling - ForecastViewModel
extension ForecastDetailed {
    
    func fillUI(withViewModel viewModel: ForecastViewModel?, atIndex index: Int) {
        //if there is an actual forecast for this index, show its detailed info
        if viewModel?.forecasts?.count ?? 0 > index { 
            guard let forecastUnit = viewModel?.forecasts?[index] else { return }
            
            let locationName = forecastUnit.location?.name ?? ""
            let locationCountry = (forecastUnit.location?.country ?? "").uppercased()
            self.locationName.text = locationName + ", " + locationCountry
            
            let dateFormatterConvert = DateFormatter()
            dateFormatterConvert.dateFormat = "dd/MM/yyyy"
            if let dateFilled = forecastUnit.date {
                self.date.text = dateFormatterConvert.string(from: dateFilled as Date)
            }
            
            if let iconNameFilled = forecastUnit.iconName {
                if iconNameFilled.last != "n" {
                    self.forecastIcon.image = UIImage(named: iconNameFilled[0...iconNameFilled.count-2] + "n")
                } else {
                    self.forecastIcon.image = UIImage(named: iconNameFilled)
                }
                self.forecastIcon.layer.cornerRadius = 5.0;
                self.forecastIcon.layer.masksToBounds = true;
            }
            self.mainTemperature.text = "\(forecastUnit.temperature?.day ?? 0)ºC"
            self.mainText.text = forecastUnit.mainText
            self.descriptionText.text = forecastUnit.descriptionText
            self.pressure.text = "Pressure: \(forecastUnit.pressure)"
            self.humidity.text = "Humidity: \(forecastUnit.humidity)"
            
            self.minTemperature.text = "Min: \(forecastUnit.temperature?.minimum ?? 0)ºC"
            self.maxTemperature.text = "Max: \(forecastUnit.temperature?.maximum ?? 0)ºC"
            
            self.morningTemperature.text = "Morning: \(forecastUnit.temperature?.morning ?? 0)ºC"
            self.eveningTemperature.text = "Evening: \(forecastUnit.temperature?.evening ?? 0)ºC"
            self.nightTemperature.text = "Night: \(forecastUnit.temperature?.night ?? 0)ºC"
            
            //Hot, cold or nothing...
            let temperature = forecastUnit.temperature?.day ?? 0
            if temperature > 25 {
                self.hotOrCold.text = "Hot"
            } else if temperature < 10 {
                self.hotOrCold.text = "Cold"
            } else {
                self.hotOrCold.text = ""
            }
        }
    }
}

//Open Weather API -> Core Data registry converter - OWForecast part
extension OWForecast {
    
    func fillInfo(intoDbObject forecastDB: Forecast, withContext contextDB: NSManagedObjectContext, intoLocation dbLocation: Location?) {
        //fill forecastDB with all OWForecast compatible variables
        forecastDB.date = self.date as NSDate?
        forecastDB.speed = self.speed ?? 0.0
        forecastDB.humidity = self.humidity ?? 0.0
        forecastDB.pressure = self.pressure ?? 0.0
        forecastDB.clouds = Int32(self.clouds ?? 0)
        forecastDB.iconName = self.iconName
        
        forecastDB.mainText = self.mainText
        forecastDB.descriptionText = self.descriptionText
        
        let newDbTemperature = Temperature(context: contextDB)
        self.temperatures?.fillInfo(intoDbObject: newDbTemperature)
        forecastDB.temperature = newDbTemperature
        
        if let dbLocationFilled = dbLocation {
            forecastDB.location = dbLocationFilled
        } else {
            let newDbLocation = Location(context: contextDB)
            self.location?.fillInfo(intoDbObject: newDbLocation)
            do {
                try contextDB.save()
            } catch {
                print("Could not save new Location context into DB - Error: \(error)")
            }
            
            forecastDB.location = newDbLocation
        }
    }
}

//Open Weather API -> Core Data registry converter - OWTemperature part
extension OWTemperature {
    
    func fillInfo(intoDbObject temperatureDB: Temperature) {
        if let dayFilled = self.day {
            temperatureDB.day = dayFilled
        }
        if let minimumFilled = self.minimum {
            temperatureDB.minimum = minimumFilled
        }
        if let maximumFilled = self.maximum {
            temperatureDB.maximum = maximumFilled
        }
        if let morningFilled = self.morning {
            temperatureDB.morning = morningFilled
        }
        if let eveningFilled = self.evening {
            temperatureDB.evening = eveningFilled
        }
        if let nightFilled = self.night {
            temperatureDB.night = nightFilled
        }
    }
}

//Open Weather API -> Core Data registry converter - OWLocation part
extension OWLocation {
    
    func fillInfo(intoDbObject locationDB: Location) {
        locationDB.country = self.country
        if let idFilled = self.id {
            locationDB.id = Int32(idFilled)
        }
        if let latitudeFilled = self.latitude {
            locationDB.lat = latitudeFilled
        }
        if let longitudeFilled = self.longitude {
            locationDB.lon = longitudeFilled
        }
        locationDB.name = self.city
        if let populationFilled = self.population {
            locationDB.population = Int32(populationFilled)
        }
        if let timezoneFilled = self.timezone {
            locationDB.timezone = Int32(timezoneFilled)
        }
    }
}
