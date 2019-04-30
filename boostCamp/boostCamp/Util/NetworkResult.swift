//
//  NetworkResult.swift
//  boostCamp
//
//  Created by 강수진 on 30/04/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkResult<T> {
    case Success(T)
    case Failure(Error)
}

enum Error {
    case decodeError
    case networkConnectFail
    case networkError((resCode : Int, msg : String))
}
