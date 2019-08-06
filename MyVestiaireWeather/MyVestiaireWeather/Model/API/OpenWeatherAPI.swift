//
//  OpenWeatherAPI.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 04/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class OpenWeatherAPI: NSObject, WebServiceResponseDelegate {
    
    private var newDataArrivedReturnBlock: ((_ forecasts: [OWForecast]) -> Void)?
    
    //Openweather API path - v2.5 - Paris - JSON - Metric
    let openWeatherPath = "api.openweathermap.org/data/2.5/forecast/daily?q=Paris&mode=json&units=metric&cnt=16&APPID=648a3aac37935e5b45e09727df728ac2"
    
    // MARK: - Properties
    private static var sharedOWAPI: OpenWeatherAPI = {
        let owAPI = OpenWeatherAPI()
        
        return owAPI
    }()
    
    class func shared() -> OpenWeatherAPI {
        return sharedOWAPI
    }
    
    // MARK: - Inits
    private override init() {
        super.init()
        
        //start webservice handler telling that its delegate is this OpenWeather's API
        WebServiceHandler.shared().start(withResponseDelegate: self)
    }
    
    func start(withReturnBlock newReturnBlock: ((_ forecasts: [OWForecast]) -> Void)?) {
        self.newDataArrivedReturnBlock = newReturnBlock
        
        //request forecast from OpenWeather using Webservice Handler -> AlamoFire
        self.requestForecast()
    }
    
    func requestForecast() {
        let newRequest = WebServiceRequest(withMethod: .get, andWithType: .https, andWithEncoder: .json, andWithPath: self.openWeatherPath, andWithHeader: ["Content-Type": "application/json"], andWithVariables: nil, andWithVariablesPurpose: .none)
        WebServiceHandler.shared().send(request: newRequest)
    }
    
    //MARK:- WebServiceResponseDelegate related methods
    func didReceiveResponse(response: WebServiceResponse, fromRequest request: WebServiceRequest) {
        //received response from webservice
        var newForecasts: [OWForecast] = []
        if let jsonDictionaryData: [String : Any] = (response.body as? [String : Any]){
            let newLocation = OWLocation(withDataDictionary: jsonDictionaryData["city"] as? [String : Any])
            
            for forecastUnitJSON in jsonDictionaryData["list"] as? [[String : Any]] ?? [] {
                let newForecast = OWForecast(withDataDictionary: forecastUnitJSON, forLocation: newLocation)
                newForecasts.append(newForecast)
            }
            
            //also, tell the upper class that new information was added to the database
            self.newDataArrivedReturnBlock?(newForecasts)
        }
    }
}
