//
//  FirstTapTVCell.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class FirstTapTVCell: UITableViewCell {
    
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var ageView: AgeView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
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
        ratingLbl.text = "평점 : "+data.userRating.description
        rankingLbl.text = "예매 순위 : "+data.reservationGrade.description
        bookingRateLbl.text = "예매율 : "+data.reservationRate.description
        dateLbl.text = data.date
    }
}

