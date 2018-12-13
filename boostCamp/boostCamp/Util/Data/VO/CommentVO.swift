//
//  CommentVO.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct CommentVO: Codable {
    let comments: [Comment]
    let movieID: String
    
    enum CodingKeys: String, CodingKey {
        case comments
        case movieID = "movie_id"
    }
}

struct Comment: Codable {
    let contents: String
    let rating: Int
    let timestamp: Double
    let movieID: String
    let writer, id: String
    
    enum CodingKeys: String, CodingKey {
        case contents, rating, timestamp
        case movieID = "movie_id"
        case writer, id
    }
}

