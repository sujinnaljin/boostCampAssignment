//
//  UrlPath.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

enum UrlPath : String {
    
    case getAllMovieList = "/movies"
    case getMovieDetail = "/movie"
    case getMovieComment = "/comments"

    func getURL(_ parameter : String? = nil) -> String{
        return "http://connect-boxoffice.run.goorm.io\(self.rawValue)\(parameter ?? "")"
    }
}
