//
//  GettableService.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
    case failure()
}

enum NetworkResult<T> {
    case networkSuccess(T)
    case serverErr
    case networkFail
    case decodeFail
}

enum HttpResponseCode: Int{
    case getSuccess = 200
    case serverErr = 500
}

protocol GettableService {
    associatedtype NetworkData : Codable
    typealias networkResult = (resCode : Int, resResult : NetworkData)
    func get(_ url:String, completion : @escaping (Result<networkResult>)->Void)
}

extension GettableService {
    func get(_ url:String, completion : @escaping (Result<networkResult>)->Void){
       
        guard let encodedUrl = url.getEncodedUrl() else {return}
        
        let defaultSession = URLSession(configuration: .default)
        
        var request = URLRequest(url: encodedUrl)
        request.httpMethod = "GET"
        
        let dataTask = defaultSession.dataTask(with: request) { (data, response, error) in
         
            if let data = data, let response = response as? HTTPURLResponse {
                let decoder = JSONDecoder()
                do {
                    let resCode = response.statusCode
                    let data = try decoder.decode(NetworkData.self, from: data)
                    let result : networkResult = (resCode, data)
                    completion(.success(result))
                }catch {
                    completion(.error("값을 지정한 json 형태로 변환할 수 없음"))
                }
            }
            guard error == nil else{
                completion(.failure())
                print(error!.localizedDescription)
                return
            }
        }
        dataTask.resume()
    }
    
}
