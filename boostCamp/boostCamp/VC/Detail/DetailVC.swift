//
//  DetailVC.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var ageView: AgeView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var runningTimeLbl: UILabel!
    @IBOutlet weak var rankingLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var totalViewCntLbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var directorLbl: UILabel!
    @IBOutlet weak var actorLbl: UILabel!
    @IBOutlet weak var ratingStarView: RatingStarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingStarView.rating = 4.3
        ageView.ageLbl = self.ageLbl
        ageView.age = .twelve
    }
}
