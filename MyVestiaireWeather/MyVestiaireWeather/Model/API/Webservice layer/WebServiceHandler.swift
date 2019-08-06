//
//  WebServiceHandler.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 04/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit
import Alamofire.Swift

class WebServiceHandler: NSObject {
    
    private var responseDelegate: WebServiceResponseDelegate?
    
    // MARK: - Properties
    private static var sharedWS_Handler: WebServiceHandler = {
        let wsHandler = WebServiceHandler()
        
        return wsHandler
    }()
    
    // MARK: - Accessors
    
    /**
     Singleton needed to use this static Class.
     */
    class func shared() -> WebServiceHandler {
        return sharedWS_Handler
    }
    
    // MARK: - Inits
    private override init() {
        super.init()
    }
    
    func start(withResponseDelegate newResponseDelegate: WebServiceResponseDelegate){
        self.responseDelegate = newResponseDelegate
    }
    
    func send(request: WebServiceRequest){
        if let fullURL: URL = request.getFullURL() {
            let newAlamoRequest = AF.request(fullURL, method: request.method.getValueAsHTTPMethod(), parameters: request.variables?.getAsStringAnyDictionary(), encoding: request.encoder.getValueAsAlamoEncoding(), headers: request.getHeaderAsAlamoProtocol())
            self.requestResponseReturnBlock(withDataRequest: newAlamoRequest, forRequest: request)
        } else {
            //Error: Did not send to webservice lower layer. //Reason: URL was not correctly returned
            request.status = .finished
        }
    }
    
    private func requestResponseReturnBlock(withDataRequest dataRequest: DataRequest, forRequest request: WebServiceRequest){
        if(request.getFullURL() == nil) { return }
        
        dataRequest.response(completionHandler: { (response) in
            request.hasFinished()
            
            //get auto response encoder (json OR text OR data OR ..)
            var autoResponseEncoder: ResponseEncoder? = .unknown
            if let responseHeaders: [String : String] = response.response?.allHeaderFields as? [String : String] {
                if let contentTypeAuto: String = responseHeaders["Content-Type"] {
                    autoResponseEncoder = ResponseEncoder(withAutoEncoder: contentTypeAuto)
                }
            }
            
            var responseObject: WebServiceResponse?
            switch response.result {
                
            case .success:
                switch autoResponseEncoder {
                case .json?:
                    do{
                        if let responseData: Data = response.value as? Data, let body = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any], let header: [String:Any] = response.response?.allHeaderFields as? [String : Any] {
                            
                            responseObject = WebServiceResponse(withStatus: .ok, withHeader: header, andWithBody: body)
                        } else {
                            var responseBodyToReturn: [String : Any]? = nil
                            if let responseData: Data = response.value as? Data, let body = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] {
                                responseBodyToReturn = body
                            }
                            responseObject = WebServiceResponse(withStatus: .ok, withHeader: response.response?.allHeaderFields as? [String : Any], andWithBody: responseBodyToReturn)
                        }
                    } catch {
                        //error
                        let message: String = "Error: App Layer Error: Code broke at WebServiceHandler - requestResponseReturnBlock - response.result - autoResponseEncoder - case .json"
                        print("Error: \(error) - \(message)")
                    }
                    
                case .data?:
                    if let body: Data = response.data, let header: [String: Any] = response.response?.allHeaderFields as? [String : Any] {
                        
                        responseObject = WebServiceResponse(withStatus: .ok, withHeader: header, andWithBody: body)
                    }
                    
                case .string?:
                    if(response.data != nil){
                        if let bodyUtf8Text = String(data: response.data!, encoding: .utf8), let header: [String: Any] = response.response?.allHeaderFields as? [String : Any] {
                            
                            responseObject = WebServiceResponse(withStatus: .ok, withHeader: header, andWithBody: bodyUtf8Text)
                        }
                    }
                    
                default:
                    if let body: Data = response.data, let header: [String: Any] = response.response?.allHeaderFields as? [String : Any] {
                        
                        responseObject = WebServiceResponse(withStatus: .ok, withHeader: header, andWithBody: body)
                    }
                }
                
                if(responseObject != nil){
                    self.responseDelegate?.didReceiveResponse(response: responseObject!, fromRequest: request)
                }
                
            case .failure(let error):
                //Error will be caught already at the
                request.tryAgain()
                print(" - Low layer Webservice Handler - Request Error for " + request.path + ". *")
                print(error)
                break
            }
        })
    }
    
}

protocol WebServiceResponseDelegate: class {
    func didReceiveResponse(response: WebServiceResponse, fromRequest request: WebServiceRequest)
}
