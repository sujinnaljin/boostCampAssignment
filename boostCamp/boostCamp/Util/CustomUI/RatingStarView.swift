//
//  RatingStarView.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

enum StarFillMode {
    case full
    case half
    case none
}

class StarImgView : UIImageView {
    var fillMode : StarFillMode = .full {
        didSet {
            update()
        }
    }
    
    func update(){
        switch self.fillMode {
        case .full:
            self.image = #imageLiteral(resourceName: "fullStar")
        case .half:
            self.image = #imageLiteral(resourceName: "halfStar")
        case .none:
            self.image = #imageLiteral(resourceName: "emptyStar")
        }
    }
    
}

class RatingStarView : UIStackView {
    var rating: Double = 4.5 {
        didSet {
            if oldValue != rating {
                update(rating)
            }
        }
    }
    
    func update(_ rating : Double){
        var rating_ = rating
        for i in (0..<5) {
            let starView = self.subviews[i] as! StarImgView
            if rating_ >= 1 {
                starView.fillMode = .full
            } else if rating_ >= 0.5 {
                starView.fillMode = .half
            } else {
                starView.fillMode = .none
            }
            rating_ -= 1
        }
    }
}

