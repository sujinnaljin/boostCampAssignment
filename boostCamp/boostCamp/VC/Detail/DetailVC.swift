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
    var networkProvider = NetworkManager.sharedInstance
    
    var commentList : [Comment] = []{
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var isFetchedComment = false
    var isFetchedMovie = false
    
    func stopAnimating(isFetchedAll : Bool){
        //Comment와 Movie가 모두 통신 성공, 혹은 둘 중 하나가 에러 결과를 받았을때 indicator가 중단될 것
        if isFetchedAll {
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.getMovieDetail()
        self.getMovieComment()
        
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
    
    //영화 정보에 관한 헤더 뷰 세팅
    func setHeaderView(data : MovieDetail){
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
    
    //이미지 클릭했을때 크게 보이도록 다른 화면으로 넘어감
    @IBAction func imageTapAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let imageVC = storyboard.instantiateViewController(withIdentifier:ImageVC.reuseIdentifier) as? ImageVC {
            imageVC.selectedImage = titleImgView.image
            self.present(imageVC, animated: true, completion: nil)
        }
    }
    
    //댓글 작성화면으로 넘어감
    @objc func writeCmt(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let commentVC = storyboard.instantiateViewController(withIdentifier:CommentVC.reuseIdentifier) as? CommentVC {
            commentVC.selectedMovie = self.selectedMovie
            commentVC.selectedMovieTitle = self.selectedMovieTitle
            self.present(commentVC, animated: true, completion: nil)
        }
    }
    
}

//tableView datasource, delegate
extension DetailVC : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let filterView = DetailHeaderView.instanceFromNib()
        filterView.writeBtn.addTarget(self, action: #selector(writeCmt), for: .touchUpInside)
        return filterView
    }
    
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
    func getMovieDetail(){
        //indicator가 돌고 있지 않다면 활성화 시킴
        if !self.activityIndicator.isAnimating {
            self.activityIndicator.startAnimating()
        }
        networkProvider.getMovieDetail(movieId: selectedMovie) { [weak self] (result) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .Success(let movieDetail):
                    self.isFetchedMovie = true
                    //두개 다 통신 결과 왔을때 indicator 중단
                    self.stopAnimating(isFetchedAll: self.isFetchedMovie && self.isFetchedComment)
                    self.setHeaderView(data: movieDetail)
                case .Failure(let errorType) :
                    //에러 왔으면 indicator 강제 중단하고 alert 띄움
                    self.stopAnimating(isFetchedAll: true)
                    self.showErrorAlert(errorType: errorType)
                }
            }
        }
    }
    
    func getMovieComment(){
        if !self.activityIndicator.isAnimating {
            self.activityIndicator.startAnimating()
        }
        networkProvider.getComments(movieId: selectedMovie) { [weak self] (result) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .Success(let commentList):
                    self.isFetchedComment = true
                    self.stopAnimating(isFetchedAll: self.isFetchedMovie && self.isFetchedComment)
                    self.commentList = commentList.comments
                case .Failure(let errorType) :
                    self.stopAnimating(isFetchedAll: true)
                    self.showErrorAlert(errorType: errorType)
                }
            }
        }
    }
}
