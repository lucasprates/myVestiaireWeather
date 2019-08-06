//
//  WebServiceResponse.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 04/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class WebServiceResponse: NSObject {
    
    //Data Objects
    var header: [String:Any]? //from Alamo Network Handler Framework
    var body: Any?   //usually in JSON or HTML format
    
    var status: ResponseStatus?
    var timestamp: Date?
    
    init(withStatus newStatus: ResponseStatus){
        self.timestamp = Date()
        
        self.status = newStatus
        
        self.header = nil
        self.body = nil
    }
    
    init(withStatus newStatus: ResponseStatus, withHeader header: [String: Any]?, andWithBody body: Any?) {
        self.timestamp = Date()
        
        self.status = newStatus
        
        self.header = header
        self.body = body
        
        super.init()
    }
    
}

enum ResponseStatus: Int {
    case undefined = -1
    case ok = 200
    case error = 400
    case timeout = 504
}

enum ResponseEncoder: Int {
    case unknown = -1
    case json = 0
    case string = 1
    case data = 2
    
    init?(withAutoEncoder autoEncoder: String) {
        let autoEncoderSliced: String = autoEncoder.slice(from: "application/", to: ";") ?? ""
        switch autoEncoderSliced {
        case "json":
            self.init(rawValue: 0)
        default:
            self.init(rawValue: -1)
        }
    }
}

