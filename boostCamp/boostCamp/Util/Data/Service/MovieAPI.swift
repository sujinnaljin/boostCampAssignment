//
//  MovieAPI.swift
//  boostCamp
//
//  Created by 강수진 on 30/04/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

enum MovieAPI  {
    case getMovieDetail(movieId : String)
    case getMovieList(orderType : OrderType)
    case getCommentList(movieId : String)
    case writeComment(movieId : String, writer : String, raiting : Double, contents : String)
    
}

extension MovieAPI {
    
    var baseURL: URL {
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io") else { fatalError("base url could not be configured")}
        return url
    }
    
    var path: String {
        switch self {
        case .getMovieList(let orderType):
            return "\(baseURL)/movies?order_type=\(orderType.rawValue)"
        case .getMovieDetail(let movieId):
            return "\(baseURL)/movie?id=\(movieId)"
        case .getCommentList(let movieId):
            return "\(baseURL)/comments?movie_id=\(movieId)"
        case .writeComment(_):
            return "\(baseURL)/comment"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMovieDetail(_), .getMovieList(_), .getCommentList(_):
            return .get
        case .writeComment(_):
            return .post
        }
    }

    var body: [String:Any] {
            switch self {
            case .writeComment(let movieId, let writer, let rating, let contents):
                let parameters : [String : Any] = ["movie_id" : movieId,
                                                      "writer" : writer,
                                                      "rating" : rating,
                                                      "contents" : contents]
                return parameters
            default :
                return [:]
            }
        }
}
