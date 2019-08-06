//
//  WebServiceRequest.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 04/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit
import Alamofire

class WebServiceRequest: NSObject {
    //Request creation variables
    var status: RequestStatus = RequestStatus.undefined
    
    var method: ProtocolMethod
    var encoder: ProtocolEncoder
    
    var type: ProtocolType
    var path: String
    
    var header: Dictionary<String, String>?
    var variablesPurpose: VariablesPurpose?
    var variables: Dictionary<String, Any?>? //parameters or body
    
    //Request Management Variables
    var scheduleTimestamp: Date?
    var timeout: RequestTimeout?
    
    override init() {
        self.method = .undefined
        self.encoder = .undefined
        self.type = .undefined
        self.path = ""
        
        super.init()
    }
    
    //Make a Request - Part 1 of 3: Fill
    init(withMethod method:ProtocolMethod, andWithType type:ProtocolType, andWithEncoder encoder: ProtocolEncoder, andWithPath path: String, andWithHeader header: Dictionary<String, String>?, andWithVariables variables: Dictionary<String, Any?>?, andWithVariablesPurpose variablesPurpose: VariablesPurpose?){
        self.method = method
        self.type = type
        self.encoder = encoder
        
        self.path = path
        
        self.variablesPurpose = variablesPurpose
        self.variables = variables
        
        self.header = header
        
        self.status = .filled
        super.init()
    }
    
    
    //Make a Request - Part 2 of 3: Schedule Request
    func fillSchedule(withTimeout timeout: RequestTimeout) {
        self.timeout = timeout
        
        self.scheduleTimestamp = Date()
        self.status = .scheduled
    }
    
    func isRunning() {
        self.status = .running
    }
    
    //Make a Request - Part 3 of 3: Response received
    func hasFinished() {
        self.status = .finished
    }
    
    func tryAgain() {
        self.status = .scheduled
    }
    
    func getFullURL() -> URL?{
        return URL(string: self.type.getPathPrefix() + self.path)
    }
    
    func shouldTryToSend() -> Bool {
        if((self.status == .running || self.status == .scheduled) && (self.timeout != RequestTimeout.undefined || self.timeout != RequestTimeout.onlyOnce)){
            
            let elapsedSeconds = Date().timeIntervalSince1970 - (scheduleTimestamp?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
            let timeoutLength = self.timeout?.rawValue ?? 0
            
            if(elapsedSeconds < timeoutLength){
                return true
            }
        }
        return false
    }
    
    func getHeaderAsAlamoProtocol() -> HTTPHeaders? {
        var alamoHeaders: [HTTPHeader] = []
        self.header?.forEach({ alamoHeaders.append(HTTPHeader(name: $0.key, value: $0.value)) })
        return HTTPHeaders(alamoHeaders)
    }
}

enum ProtocolType: String {
    case undefined = "undefined"
    case http = "http"
    case https = "https"
    
    func getPathPrefix() -> String {
        return self.rawValue + "://"
    }
    
    func getAsIntegerCode() -> Int {
        switch self {
        case .http:
            return 0
        case .https:
            return 1
        default:
            return -1
        }
    }
    
    static func getFromCode(integerCode: Int) -> ProtocolType {
        if integerCode == 0 {
            return .http
        } else if integerCode == 1 {
            return .https
        } else {
            return .undefined
        }
    }
}

enum ProtocolMethod: String {
    case undefined = "undefined"
    case get = "get"
    case post = "post"
    
    func getValueAsHTTPMethod() -> HTTPMethod {
        return HTTPMethod(rawValue: self.rawValue.uppercased()) ?? HTTPMethod.post
    }
}

enum ProtocolEncoder: String {
    case undefined = "undefined"
    case json = "json"
    case utf8 = "utf-8"
    
    func getValueAsAlamoEncoding() -> ParameterEncoding {
        switch self {
        case .json:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}

enum RequestTimeout: Double {
    case undefined = -1
    case onlyOnce = 0           //only once (0 minutes)
    case short = 60             //1 miunute
    case medium = 300           //5 minutes
    case long = 1200            //20 minutes
    case untilShutdown = 86400  //1 day, just a standard high number
    
    func getTimeoutDate() -> Date {
        if(self != .undefined){
            return Date(timeIntervalSinceNow: self.rawValue)
        }else { return Date() }
    }
}

enum RequestStatus: Int {
    case undefined = -1
    case filled = 0
    case scheduled = 2
    case running = 3
    case finished = 4
}

enum VariablesPurpose: String {
    case undefined = "undefined"
    case path = "path"
    case body = "body"
}

