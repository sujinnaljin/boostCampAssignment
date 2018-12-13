//
//  DetailTVCell.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class DetailTVCell: UITableViewCell {
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
     @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var ratingStarView: RatingStarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(data : Comment){
        nicknameLbl.text = data.writer
        dateLbl.text = data.timestamp.timeStampToDate()
        reviewLbl.text = data.contents
        ratingStarView.rating = Double(data.rating)
    }
}
