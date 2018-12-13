//
//  FirstTapVC.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class FirstTapVC: UIViewController{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getMovieStatusInfo(_:)), name: MOVIE_STATUS_NOTI, object: nil)
        setupTableView()
        setFirstData()
    }
    
    @IBAction func settingAction(_ sender: Any) {
        orderAction { (orderType) in
            DataCenter.shared().selectedOrder = orderType
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    func setFirstData(){
        DataCenter.shared().selectedOrder = .reservationRate
        self.activityIndicator.startAnimating()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(startReload(_:)), for: .valueChanged)
    }
    
    @objc func startReload(_ sender: UIRefreshControl){
       DataCenter.shared().selectedOrder = DataCenter.shared().selectedOrder
    }
   
    @objc func getMovieStatusInfo(_ notification : Notification) {
        if let status = (notification.userInfo?["status"] as? NetworkResult<Any>){
            self.activityIndicator.stopAnimating()
            tableView.refreshControl?.endRefreshing()
            switch status {
            case .networkSuccess(_):
                self.tableView.reloadData()
                self.navigationItem.title = notification.userInfo?["title"] as? String
            case .decodeFail:
                self.simpleAlert(title: "오류가 발생했습니다", message: "다시 시도해주세요")
            case .networkFail:
                self.simpleAlert(title: "네트워크 연결 실패", message: "네트워크 연결상태를 확인해주세요")
            default :
                break
            }
        }
    }
}

extension FirstTapVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataCenter.shared().movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:FirstTapTVCell.reuseIdentifier, for: indexPath) as! FirstTapTVCell
        guard DataCenter.shared().movies.count > 0 else {return cell}
        cell.configure(data: DataCenter.shared().movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier:DetailVC.reuseIdentifier) as? DetailVC {
            detailVC.selectedMovie = DataCenter.shared().movies[indexPath.row].id
            detailVC.selectedMovieTitle = DataCenter.shared().movies[indexPath.row].title
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
