//
//  AgeView.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

enum MovieAge : Int, Codable {
    case all = 0
    case twelve = 12
    case fifteen = 15
    case nineteen = 19
}

class AgeView : UIView {
    var age : MovieAge = .all {
        didSet {
            update()
        }
    }
    
    var ageLbl : UILabel?
    func update(){
        self.ageLbl?.text = self.age.rawValue.description
        switch self.age {
        case .all:
           self.backgroundColor = .green
        case .twelve:
            self.backgroundColor = .blue
        case .fifteen:
            self.backgroundColor = .yellow
        case .nineteen :
            self.backgroundColor = .red
        }
    }
}
