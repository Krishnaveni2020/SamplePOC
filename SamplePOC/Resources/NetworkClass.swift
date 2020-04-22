//
//  NetworkClass.swift
//  SamplePOC
//
//  Created by Krishnaveni on 4/21/20.
//  Copyright © 2020 Krishnaveni. All rights reserved.

import UIKit

// if any error code existed in response at any APIs calling time.
// we will get kNotify_ErrorCodes notification.
let kNotify_ErrorCodes = Notification.Name("Notify_ErrorCodes")

let BASEURL  = "http://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts"

// base class...
class VKAPIs: NSObject {
    
    // instance
    static let shared = VKAPIs()
    // assign basic url path (ex: x.x.x.x/index.php)
    var basicURL = String()
    // assign request headers as key and values
    var headers: [String: String] = [:]
}

extension VKAPIs {
    
    // convert json sting to object
    static func getObject(jsonString: String) -> Any {
        
        // convert string into data...
        if let dateObj = jsonString.data(using: String.Encoding.utf8) {
            do {
                // data convert into any object...
                let finalObj = try JSONSerialization.jsonObject(with: dateObj, options: []) as Any
                return finalObj
            } catch let error as NSError {
                print("Json string to object failed : \(error.localizedDescription)")
            }
        }
        return ""
    }
    
    //
    // convert object to json sting
    static func getJSONString(object: Any) -> String {
        
        // if object is already string...
        if object is String {
            return (object as? String)!
        }
        do {
            // convert object into data...
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: [])
            
            // getting jsonString...
            let stringObj = String(data: jsonData, encoding: .utf8)
            return stringObj!
        } catch let error as NSError {
            print("Json object to string failed : \(error.localizedDescription)")
        }
        return ""
    }
}

extension VKAPIs {
    
    //
    // Parameters:- request body as weburl formate
    // - file: file name after the base_url
    // - httpMethod: GET, POST, UPDATE, DELETE (Ex: VKMethodType.GET)
    // - handler: we will get -result Object, -success state, -error
    //
    //
    func getRequest(httpMethod: VKMethodType,
                    handler: @escaping CompletionHandler) -> Void {
        
        // generating url...
        let urlString = "\(basicURL)"
        var url_final: URL?
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
            url_final = url
        } else {
            handler(nil, false, nil)
            return
        }
        
        // get request...
        let request = VKAPIsClient().getRequest(url: url_final!, httpMethod: httpMethod)
        print("URL :-> \(httpMethod.rawValue) : \(urlString)")
    
        // calling apis...
        let task = VKAPIsClient.sessionConfiguration().dataTask(with: request)
        { (data, response, error) in
            
            // final response getting...
            if error != nil {
                handler(nil, false, error as NSError?)
            } else {
                
                handler(data, true, error as NSError?)
            }
        }
        task.resume()
    }
}

// appending string...
extension Data {
    mutating func append(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}

// typealias declaration...
typealias CompletionHandler = (_ resultObject: Any?, _ success: Bool, _ error: Error?) -> Void
typealias VKMethodType = VKAPIsClient.HttpMethods
class VKAPIsClient: NSObject {
    
    // httpMethod types...
    enum HttpMethods: String {
        case POST = "POST"
        case GET = "GET"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    static func sessionConfiguration() -> URLSession {
        
        // configuration session...
        let defaultConfigur = URLSessionConfiguration.default
        let defaultSession = URLSession.init(configuration: defaultConfigur,
                                             delegate: nil,
                                             delegateQueue: OperationQueue.main)
        return defaultSession
    }
    
    func getParamString(params: [String: String]?) -> String {
        
        // getting params string...
        var requestString = ""
        if params != nil {
            for (key, value) in params! {
                if requestString.count == 0 {
                    requestString = "\(key)=\(value)"
                } else {
                    requestString = "\(requestString)&\(key)=\(value)"
                }
            }
        }
        return requestString
    }
    
    func getHeaders(requests: URLRequest) -> URLRequest {
        
        // adding headers...
        var request = requests as URLRequest
        for (key, value) in VKAPIs.shared.headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    func getRequest(url: URL, httpMethod: VKMethodType) -> URLRequest {
        
        // generate request...
        var request = URLRequest.init(url: url)
        request.httpMethod = httpMethod.rawValue
        return getHeaders(requests: request)
    }
    
}

extension VKAPIs {
    //
    // Error code checking if its existed in the list notify-error code
    //
    func sessionOrTokenExpiryCodes(result_obj: Any) {
        if let result_dict = result_obj as? [String: Any] {
            
            // error code is number...
            if let error_code = result_dict["error"] {
                NotificationCenter.default.post(name: kNotify_ErrorCodes, object: "\(error_code)", userInfo: nil)
            }
        }
    }
}
