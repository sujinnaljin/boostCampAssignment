//
//  Movies.swift
//  boostCamp
//
//  Created by 강수진 on 30/04/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

struct Movies: Codable {
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

struct MovieDetail: Codable {
    let duration: Int
    let title: String
    let reservationRate: Double
    let actor: String
    let image: String
    let id: String
    let grade: MovieAge
    let genre: String
    let userRating: Double
    let date: String
    let reservationGrade: Int
    let director: String
    let audience: Int
    let synopsis: String
    
    enum CodingKeys: String, CodingKey {
        case duration, title
        case reservationRate = "reservation_rate"
        case actor, image, id, grade, genre
        case userRating = "user_rating"
        case date
        case reservationGrade = "reservation_grade"
        case director, audience, synopsis
    }
}
