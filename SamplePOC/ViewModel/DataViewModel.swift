//
//  DataModelLogic.swift
//  SamplePOC
//
//  Created by Krishnaveni on 4/20/20.
//  Copyright © 2020 Krishnaveni. All rights reserved.
//

import UIKit
import Foundation
import Reachability

class ViewModel {
    
    // MARK: - Closure use for notification
    var reloadList = {() -> () in }
    var errorMessage = {(message : String) -> () in }
    
    // MARK: - Array of List Model class
    var dataModelArr : [DataModel] = []{
        didSet{
            reloadList()
        }
    }
    
    // MARK: - Class veriables
    var mainData : MainData?
    
    // MARK: - API Service Call
    func getServicecall() {
        
        NetworkManager.isUnreachable { networkManagerInstance in
          self.errorMessage("Check Your Internet Connection!!!")
            return
        }
        
            VKAPIs.shared.getRequest(httpMethod: .GET) { (resultObject, success, error) in
                if success == true
                {
                    let responseStr = String(data: (resultObject as? Data)!, encoding: String.Encoding.isoLatin1)
                    guard let modifiedData = responseStr?.data(using: String.Encoding.utf8) else {
                        print("could not convert data to UTF-8 format")
                        return
                    }
                    do {
                        
                        let decoder = JSONDecoder()
                        self.mainData = try decoder.decode(MainData.self, from: modifiedData)
                        DispatchQueue.main.async {
                            
                            let objects: [DataModel] =  (self.mainData?.rows)!
                            self.dataModelArr = objects.filter { $0.title != nil } //removed nil row
                        }
                    } catch {
                        self.errorMessage("Oops,something went wrong!,Please try again later!!!")
                    }
                    
                } else {
                    self.errorMessage("Oops,something went wrong!,Please try again later!!!")
                }
                
            }
    }
}
