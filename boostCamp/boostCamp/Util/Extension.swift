//
//  Extension.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 13..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
extension UIViewController {
    func simpleAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func orderAction(orderHandler : @escaping (_ orderType : OrderType)->Void){
    
        let alert = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤방식으로 정렬할까요?", preferredStyle: .actionSheet)
        
        let reservationRateOrder = UIAlertAction(title: "예매율", style: .default) { (re1) in
            orderHandler(.reservationRate)
        }
        let curationOrder = UIAlertAction(title: "큐레이션", style: .default) { (re2) in
            orderHandler(.curation)
        }
        let openDateOrder = UIAlertAction(title: "개봉일", style: .default) { (re3) in
            orderHandler(.openDate)
        }
        let cancleAction = UIAlertAction(title: "취소",style: .cancel)
 
        alert.addAction(reservationRateOrder)
        alert.addAction(curationOrder)
        alert.addAction(openDateOrder)
        alert.addAction(cancleAction)
        present(alert, animated: true)
    }
}

extension NSObject {
    static var reuseIdentifier:String {
        return String(describing:self)
    }
}

extension UIView {
    func makeRounded(){
        self.layer.cornerRadius = self.layer.frame.height/2
        self.layer.masksToBounds = true
    }
}

extension String {
    func getEncodedUrl() -> URL? {
      return  URL(string:self.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)
    }
}


extension UIImageView {
    //TODO :- 백그라운드?
    func setImageWithUrl(_ url : URL){
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

extension Int{
    func getPortionalLength() -> CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        return (CGFloat(self)/375)*screenSize.width
    }
}

extension Double{
    func timeStampToDate(dateFormat : String = "yyyy-MM-dd hh:mm:ss") -> String{
        let unixTimestamp = (self)
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormat
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
