//
//  ForecastViewModelTests.swift
//  MyVestiaireWeatherTests
//
//  Created by Lucas on 07/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import XCTest

class ForecastViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateReturnBlock() {
        let expectationTest = expectation(description: "Test Update Return Block")
        let _ = ForecastViewModel {
            XCTAssert(true)
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
