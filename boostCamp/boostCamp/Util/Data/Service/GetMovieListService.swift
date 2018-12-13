//
//  GetMovieListService.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct GetMovieListService: GettableService {
    typealias NetworkData = MovieListVO
    static let shareInstance = GetMovieListService()
    func getMovieList(url : String, completion : @escaping (NetworkResult<Any>) -> Void){
        get(url) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.getSuccess.rawValue : completion(.networkSuccess(networkResult.resResult))
                case HttpResponseCode.serverErr.rawValue :
                    completion(.serverErr)
                default :
                    print("neither 200 nor 500. rescode is \(networkResult.resCode)")
                    break
                }
                break
            case .error(let errMsg) :
                print(errMsg)
                completion(.decodeFail)
                break
            case .failure :
                completion(.networkFail)
            }
        }
    }
}
