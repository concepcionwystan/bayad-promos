//
//  PUTPromoRequest.swift
//  Bayad Promos
//
//  Created by Application Developer 9 on 8/18/21.
//

import Foundation

struct PUTPromoRequest: Codable{
    private(set) var name: String!
    private(set) var details: String!
    private(set) var image: String!
    private(set) var read: Int!
    
    enum CodingKeys: String, CodingKey {
        case name
        case details
        case image = "image_url"
        case read
    }
    
    init(name: String, details: String, image: String, read: Int){
        self.name = name
        self.details = details
        self.image = image
        self.read = read
    }
}
