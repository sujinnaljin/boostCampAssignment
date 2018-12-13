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
