//
//  FirstTapVC.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class FirstTapVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var movieList : [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getMovieList(url: UrlPath.getAllMovieList.getURL("?order_type=1"))
        }
        setupTableView()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FirstTapVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:FirstTapTVCell.reuseIdentifier, for: indexPath) as! FirstTapTVCell
        guard movieList.count > 0 else {return cell}
        cell.configure(data: movieList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movieList[indexPath.row]
        
    }
}


//통신
extension FirstTapVC {
    func getMovieList(url : String){
        GetMovieListService.shareInstance.getMovieList(url: url){ [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let movieList):
                guard let movieList = movieList as? MovieListVO else {return}
                self.movieList = movieList.movies
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결상태를 확인해주세요")
            default :
                break
            }
        }
    }
}
