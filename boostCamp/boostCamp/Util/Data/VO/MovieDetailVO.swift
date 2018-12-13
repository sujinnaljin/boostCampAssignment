//
//  MovieDetailVO.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct MovieDetailVO: Codable {
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
