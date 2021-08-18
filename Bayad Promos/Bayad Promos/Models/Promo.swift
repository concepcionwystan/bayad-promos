//
//  Promo.swift
//  Bayad Promos
//
//  Created by Application Developer 9 on 8/18/21.
//

import Foundation

struct Promo: Codable{
    private(set) var id: String!
    private(set) var name: String!
    private(set) var details: String!
    private(set) var image: String!
    private(set) var read: Int!
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case details
        case image = "image_url"
        case read
    }
}
