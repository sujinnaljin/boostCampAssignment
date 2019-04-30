//
//  NetworkManager.swift
//  boostCamp
//
//  Created by 강수진 on 30/04/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

struct NetworkManager : Networkable {
    static let sharedInstance = NetworkManager()
    
    func writeComment(movieId : String, writer : String, raiting : Double, contents : String, completion: @escaping (NetworkResult<WriteComment>) -> ()) {
        fetchData(api: .writeComment(movieId: movieId, writer: writer, raiting: raiting
            , contents: contents), networkData: WriteComment.self) { (result) in
            switch result {
            case .Success(let successResult):
                completion(.Success((successResult.resResult)))
            case .Failure(let errorType) :
                switch errorType {
                case .networkConnectFail:
                    completion(.Failure(.networkConnectFail))
                case .networkError(let resCode, let msg):
                    completion(.Failure(.networkError((resCode, msg))))
                case .decodeError:
                    completion(.Failure(.decodeError))
                }
            }
        }
    }
    
    func getMovieList(orderType: OrderType, completion: @escaping (NetworkResult<Movies>) -> ()) {
        fetchData(api: .getMovieList(orderType: orderType), networkData: Movies.self) { (result) in
            switch result {
            case .Success(let successResult):
                completion(.Success((successResult.resResult)))
            case .Failure(let errorType) :
                switch errorType {
                case .networkConnectFail:
                    completion(.Failure(.networkConnectFail))
                case .networkError(let resCode, let msg):
                    completion(.Failure(.networkError((resCode, msg))))
                case .decodeError:
                    completion(.Failure(.decodeError))
                }
            }
        }
    }
    
    func getComments(movieId: String, completion: @escaping (NetworkResult<Comments>) -> ()) {
        fetchData(api: .getCommentList(movieId: movieId), networkData: Comments.self) { (result) in
            switch result {
            case .Success(let successResult):
                completion(.Success((successResult.resResult)))
            case .Failure(let errorType) :
                switch errorType {
                case .networkConnectFail:
                    completion(.Failure(.networkConnectFail))
                case .networkError(let resCode, let msg):
                    completion(.Failure(.networkError((resCode, msg))))
                case .decodeError:
                    completion(.Failure(.decodeError))
                }
            }
        }
    }
    
    func getMovieDetail(movieId: String, completion: @escaping (NetworkResult<MovieDetail>) -> ()) {
        fetchData(api: .getMovieDetail(movieId: movieId), networkData: MovieDetail.self) { (result) in
            switch result {
            case .Success(let successResult):
                completion(.Success((successResult.resResult)))
            case .Failure(let errorType) :
                switch errorType {
                case .networkConnectFail:
                    completion(.Failure(.networkConnectFail))
                case .networkError(let resCode, let msg):
                    completion(.Failure(.networkError((resCode, msg))))
                case .decodeError:
                    completion(.Failure(.decodeError))
                }
            }
        }
    }
}

