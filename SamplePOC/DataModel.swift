//
//  DataModel.swift
//  SamplePOC
//
//  Created by Krishnaveni on 4/19/20.
//  Copyright © 2020 Krishnaveni. All rights reserved.
//

import Foundation

struct MainData : Codable{
    
    let title : String?
    let datamodel : [DataModel]?
     enum CodingKeys: String, CodingKey {
       case title = "title"
       case datamodel = "rows"
    }
}

struct DataModel : Codable{
    let title : String?
    let description : String?
    let imageHref : String?
    
    enum CodingKeys: String, CodingKey {
           case title = "title"
           case description = "description"
           case imageHref = "imageHref"
       }
}
