//
//  MovieListVO.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct MovieListVO: Codable {
    let movies: [Movie]
    let orderType: Int
    
    enum CodingKeys: String, CodingKey {
        case movies
        case orderType = "order_type"
    }
}

struct Movie: Codable {
    let title: String
    let reservationRate: Double
    let id: String
    let grade: MovieAge
    let userRating: Double
    let date: String
    let reservationGrade: Int
    let thumb: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case reservationRate = "reservation_rate"
        case id, grade
        case userRating = "user_rating"
        case date
        case reservationGrade = "reservation_grade"
        case thumb
    }
}
