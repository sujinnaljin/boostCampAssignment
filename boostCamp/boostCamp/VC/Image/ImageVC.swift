//
//  ImageVC.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 14..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {

    var selectedImage : UIImage?
    @IBOutlet weak var movieImgView: UIImageView!

    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedImage_ = selectedImage {
            self.movieImgView.image = selectedImage_
        }
    }

}
