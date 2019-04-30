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
    
    //정렬 순서 바뀔때 마다 다시 통신해서 moives에 담아준다.
    var selectedOrder : OrderType? {
        didSet {
            self.getMovieList()
        }
    }
    
    //통신해서 가지고 온 영화 데이터. 첫번째 뷰나 두번째 뷰의 datasource가 될 것.
    var movies:[Movie] = []
}

//통신
extension DataCenter {
    func getMovieList(){
        guard let selectedOrder = self.selectedOrder else { return }
        NetworkManager.sharedInstance.getMovieList(orderType: selectedOrder){ (result) in
            switch result {
            case .Success(let movieList):
                DataCenter.shared().movies = movieList.movies
            default :
                break
            }
            DispatchQueue.main.async {
                var navTitle = ""
                switch selectedOrder {
                case .reservationRate:
                    navTitle = "예매율순"
                case .curation:
                    navTitle = "큐레이션순"
                case .openDate:
                    navTitle = "개봉일순"
                }
                let statusInfo : [String : Any] = ["status" : result , "title" : navTitle]
                //통신 완료하고 노티 날려줌. 정렬 기준(title)이랑 성공 여부(status) 담겨 있음.
                NotificationCenter.default.post(name: MOVIE_STATUS_NOTI, object: nil, userInfo: statusInfo)
            }
        }
    }
}
