//
//  DetailVC.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
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
    
    var selectedMovie = ""
    var selectedMovieTitle = ""
    
    var commentList : [Comment] = []{
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var isFetchedComment = false
    var isFetchedMovie = false
    
    func stopAnimating(isFetchedAll : Bool){
        if isFetchedAll {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            self.getMovieDetail(url:  UrlPath.getMovieDetail.getURL("?id=\(self.selectedMovie)"))
            self.getMovieComment(url: UrlPath.getMovieComment.getURL("?movie_id=\(self.selectedMovie)"))
        }
        self.navigationItem.title = selectedMovieTitle
        setupTableView()
        ageView.makeRounded()
        ageView.ageLbl = self.ageLbl
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        if let headerView = tableView.tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            tableView.tableHeaderView = headerView
        }
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setHeaderView(data : MovieDetailVO){
        guard let encodedThumbUrl = data.image.getEncodedUrl() else {return}
        titleImgView.setImageWithUrl(encodedThumbUrl)
        ageView.age = data.grade
        titleLbl.text = data.title
        dateLbl.text = data.date+" 개봉"
        genreLbl.text = data.genre
        runningTimeLbl.text = data.duration.description+"분"
        rankingLbl.text = "\(data.reservationGrade)위 \(data.reservationRate)%"
        ratingLbl.text = data.userRating.description
        totalViewCntLbl.text = data.audience.description
        summaryLbl.text = data.synopsis
        directorLbl.text = data.director
        actorLbl.text = data.actor
        ratingStarView.rating = data.userRating
    }
}

extension DetailVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:DetailTVCell.reuseIdentifier, for: indexPath) as! DetailTVCell
        guard commentList.count > 0 else {return cell}
        cell.configure(data: commentList[indexPath.row])
        return cell
    }
}

//통신
extension DetailVC {
    func getMovieDetail(url : String){
        GetMovieDetailService.shareInstance.getMovieDetail(url: url){ [weak self] (result) in
            guard let `self` = self else { return }
            self.isFetchedMovie = true
            self.stopAnimating(isFetchedAll: self.isFetchedMovie && self.isFetchedComment)
            switch result {
            case .networkSuccess(let movieDetail):
                guard let movieDetail = movieDetail as? MovieDetailVO else {return}
                DispatchQueue.main.async {
                   self.setHeaderView(data: movieDetail)
                }
            case .decodeFail :
                self.simpleAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            case .networkFail :
                self.simpleAlert(title: "네트워크 연결 실패", message: "네트워크 연결상태를 확인해주세요")
            default :
                break
            }
        }
    }
    
    func getMovieComment(url : String){
        GetCommentService.shareInstance.getCommentList(url: url){ [weak self] (result) in
            guard let `self` = self else { return }
            self.isFetchedComment = true
            switch result {
            case .networkSuccess(let commentList):
                self.stopAnimating(isFetchedAll: self.isFetchedMovie && self.isFetchedComment)
                guard let commentList = commentList as? CommentVO else {return}
                self.commentList = commentList.comments
            case .decodeFail :
                self.stopAnimating(isFetchedAll: true)
                self.simpleAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            case .networkFail :
                self.stopAnimating(isFetchedAll: true)
                self.simpleAlert(title: "네트워크 연결 실패", message: "네트워크 연결상태를 확인해주세요")
            default :
                break
            }
        }
    }
}
