//
//  Networkable.swift
//  boostCamp
//
//  Created by 강수진 on 30/04/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import Foundation

protocol Networkable {
    func getMovieList(orderType: OrderType, completion: @escaping (NetworkResult<Movies>) -> ())
    func getComments(movieId: String, completion: @escaping (NetworkResult<Comments>) -> ())
    func getMovieDetail(movieId: String, completion: @escaping (NetworkResult<MovieDetail>) -> ())
    func fetchData<T: Codable>(api : MovieAPI, networkData : T.Type, completion : @escaping (NetworkResult<(resCode : Int, resResult : T)>)->Void)
}

extension Networkable {
    func fetchData<T: Codable>(api : MovieAPI, networkData : T.Type, completion : @escaping (NetworkResult<(resCode : Int, resResult : T)>)->Void){
        
        guard let encodedUrl = api.path.getEncodedUrl() else {return}
    
        let defaultSession = URLSession.shared
        
        var request = URLRequest(url: encodedUrl)
        request.httpMethod = api.method.rawValue
        
        if api.method == .post {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: api.body, options: []) else {
                return
            }
             request.httpBody = httpBody
        }
        
        let dataTask = defaultSession.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                if let err = error as NSError?, err.code == -1009 {
                    completion(.Failure(.networkConnectFail))
                }
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                let resCode = response.statusCode
                switch resCode{
                case 200..<400:
                    do {
                        let data = try JSONDecoder().decode(T.self, from: data)
                        completion(.Success((resCode, data)))
                    } catch {
                        completion(.Failure(.decodeError))
                    }
                default :
                    completion(.Failure(.networkError((resCode, error?.localizedDescription ?? ""))))
                }
            }
        }
        dataTask.resume()
    }
}
