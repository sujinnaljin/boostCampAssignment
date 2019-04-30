//
//  Comment.swift
//  boostCamp
//
//  Created by 강수진 on 30/04/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

struct Comments: Codable {
    let comments: [Comment]
    let movieID: String
    
    enum CodingKeys: String, CodingKey {
        case comments
        case movieID = "movie_id"
    }
}


struct Comment: Codable {
    let contents: String
    let rating: Double
    let timestamp: Double
    let movieID: String
    let writer, id: String
    
    enum CodingKeys: String, CodingKey {
        case contents, rating, timestamp
        case movieID = "movie_id"
        case writer, id
    }
}

struct WriteComment: Codable {
    let contents: String
    let rating: Double
    let movieID: String
    let writer: String
    
    enum CodingKeys: String, CodingKey {
        case contents, rating
        case movieID = "movie_id"
        case writer
    }
}
