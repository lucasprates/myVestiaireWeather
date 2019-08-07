//
//  OpenWeatherAPITests.swift
//  MyVestiaireWeatherTests
//
//  Created by Lucas on 07/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import XCTest

class OpenWeatherAPITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testServerAvaliability() {
        let expectationTest = expectation(description: "Test Server Avaliability")
        OpenWeatherAPI.shared().start { (forecasts: [OWForecast]?) in
            XCTAssert(forecasts != nil)
            expectationTest.fulfill()
        }
        
        waitForExpectations(timeout: 90) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testResponseForecastsCount() {
        let expectationTest = expectation(description: "Test Response Forecasts Count")
        OpenWeatherAPI.shared().start { (forecasts: [OWForecast]?) in
            XCTAssert(forecasts?.count ?? 0 == 16)
            expectationTest.fulfill()
        }
        
        waitForExpectations(timeout: 90) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testResponseLocationFilled() {
        let expectationTest = expectation(description: "Test Response Location Filled")
        OpenWeatherAPI.shared().start { (forecasts: [OWForecast]?) in
            for forecastUnit in forecasts ?? [] {
                if let locationUnit = forecastUnit.location {
                    XCTAssert(locationUnit.id != nil)
                }
            }
            expectationTest.fulfill()
        }
        
        waitForExpectations(timeout: 90) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testResponseForecastFilled() {
        let expectationTest = expectation(description: "Test Response Forecast Filled")
        
        //test if Open Weather API Request returns forecasts all with future predictions
        OpenWeatherAPI.shared().start { (forecasts: [OWForecast]?) in
            for forecastUnit in forecasts ?? [] {
                if let dateFilled = forecastUnit.date {
                    XCTAssert(dateFilled.timeIntervalSince1970 > Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)
                }
            }
            expectationTest.fulfill()
        }
        
        waitForExpectations(timeout: 90) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testResponseTemperaturesFilled() {
        let expectationTest = expectation(description: "Test Response Temperatures Filled")
        
        //test if Open Weather API Request returns forecasts all with future predictions
        OpenWeatherAPI.shared().start { (forecasts: [OWForecast]?) in
            for forecastUnit in forecasts ?? [] {
                if let temperaturesFilled = forecastUnit.temperatures {
                    XCTAssert(temperaturesFilled.day != nil)
                    XCTAssert(temperaturesFilled.evening != nil)
                    XCTAssert(temperaturesFilled.maximum != nil)
                    XCTAssert(temperaturesFilled.minimum != nil)
                    XCTAssert(temperaturesFilled.morning != nil)
                    XCTAssert(temperaturesFilled.night != nil)
                }
            }
            expectationTest.fulfill()
        }
        
        waitForExpectations(timeout: 90) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
