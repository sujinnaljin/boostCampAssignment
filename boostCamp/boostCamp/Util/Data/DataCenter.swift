//
//  DataCenter.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation


enum OrderType : Int{
    case reservationRate = 0
    case curation = 1
    case openDate = 2
}


let MOVIE_STATUS_NOTI = NSNotification.Name("movieStatus")

class DataCenter {
    
    struct StaticInstance {
        static var instance: DataCenter?
    }
    
    class func shared() -> DataCenter {
        if StaticInstance.instance == nil {
            StaticInstance.instance = DataCenter()
        }
        return StaticInstance.instance!
    }
    
    var selectedOrder : OrderType? {
        didSet {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let `self` = self, let selectedOrder = self.selectedOrder else { return }
                
                self.getMovieList(url: UrlPath.getAllMovieList.getURL("?order_type="+selectedOrder.rawValue.description))
            }
        }
    }
    
    var movies:[Movie] = []
    
    func getMovieList(url : String){
        GetMovieListService.shareInstance.getMovieList(url: url){ (result) in
            switch result {
            case .networkSuccess(let movieList):
                guard let movieList = movieList as? MovieListVO else {return}
                DataCenter.shared().movies = movieList.movies
            default :
                break
            }
            DispatchQueue.main.async {
                var navTitle = ""
                switch self.selectedOrder! {
                case .reservationRate:
                    navTitle = "예매율순"
                case .curation:
                    navTitle = "큐레이션순"
                case .openDate:
                    navTitle = "개봉일순"
                }
                let statusInfo : [String : Any] = ["status" : result , "title" : navTitle]
                NotificationCenter.default.post(name: MOVIE_STATUS_NOTI, object: nil, userInfo: statusInfo)
            }
        }
    }
}


