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
    let rows : [DataModel]?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case rows = "rows"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        rows = try values.decodeIfPresent([DataModel].self, forKey: .rows)
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        imageHref = try values.decodeIfPresent(String.self, forKey: .imageHref)
    }
}
