//
//  DetailHeaderView.swift
//  boostCamp
//
//  Created by 강수진 on 30/04/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {
    
    @IBOutlet weak var writeBtn: UIButton!
    @IBOutlet weak var titleLbl : UILabel!
    
    class func instanceFromNib() -> DetailHeaderView {
        let view = UINib(nibName: "DetailHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DetailHeaderView
        return view
    }
}
