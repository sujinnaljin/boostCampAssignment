//
//  CommentVC.swift
//  boostCamp
//
//  Created by 강수진 on 30/04/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

//TODO : 완성 못함. 1.별점 만들고 2.유저 이름 저장하고 3. 통신 성공했을때 전 뷰로 돌아가면서 댓글 리로드
class CommentVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var networkProvider = NetworkManager.sharedInstance
    var selectedMovie = "" //movieId
    var selectedMovieTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        titleLbl.text = selectedMovieTitle
    }
    
    
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func writeBtn(_ sender: Any) {
        if let writer = txtField.text, let content = txtView.text, !content.isEmpty, !writer.isEmpty {
            //rating 임의 작성
            writeComment(movieId: selectedMovie, writer: writer, rating: 5.0, contents: content)
        } else {
            self.simpleAlert(title: "오류", message: "모든 필드를 작성해주세요")
            
        }
    }
    
}

//통신
extension CommentVC {
    func writeComment(movieId : String, writer : String, rating : Double, contents : String){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        networkProvider.writeComment(movieId: movieId, writer: writer, raiting: rating, contents: contents) { [weak self] (result) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                switch result {
                case .Success(_):
                    self.dismiss(animated: true, completion: nil)
                case .Failure(let errorType) :
                    self.showErrorAlert(errorType: errorType)
                }
            }
        }
    }
}
