//
//  SecondTapCVCell.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SecondTapCVCell: UICollectionViewCell {
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var ageView: AgeView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rankingLbl: UILabel!
    @IBOutlet weak var bookingRateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ageView.ageLbl = ageLbl
        ageView.makeRounded()
    }
    
    func configure(data : Movie){
        guard let encodedThumbUrl = data.thumb.getEncodedUrl() else {return}
        titleImgView.setImageWithUrl(encodedThumbUrl)
        ageView.age = data.grade
        titleLbl.text = data.title
        rankingLbl.text = "\(data.reservationGrade)위(\(data.userRating))"
        bookingRateLbl.text = "\(data.reservationRate)%"
        dateLbl.text = data.date
    }
}
