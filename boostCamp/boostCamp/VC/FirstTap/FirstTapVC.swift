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
        //노티 설정
        NotificationCenter.default.addObserver(self, selector: #selector(getMovieStatusInfo(_:)), name: MOVIE_STATUS_NOTI, object: nil)
        setupTableView()
        setFirstData()
    }
    
    @IBAction func settingAction(_ sender: Any) {
        orderAction { (orderType) in
            //action sheet에서 선택한 값 받아서 데이터센터의 selectedOrder에 할당해줌.
            DataCenter.shared().selectedOrder = orderType
            //selectedOrder가 바뀔때마다 통신하게 코드 작성했으므로 activityIndicator도 활성화
            self.activityIndicator.startAnimating()
        }
    }
    
    func setFirstData(){
        //처음 뷰 로드 되었을때 정렬기준은 예매율순
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
        //현재 설정되어있는 값 그대로 다시 넣어주면 됨
       DataCenter.shared().selectedOrder = DataCenter.shared().selectedOrder
    }
   
    //노티 받아서 실행될 함수
    @objc func getMovieStatusInfo(_ notification : Notification) {
        if let status = (notification.userInfo?["status"] as? NetworkResult<Movies>){
            self.activityIndicator.stopAnimating()
            tableView.refreshControl?.endRefreshing()
            switch status {
            case .Success(_):
                //노티 받아서 온 상태가 성공이면 tableView 갱신.
                //tableView datasource 는 DataCenter의 moives이고, 이미 DataCenter에서는 통신 성공 후 movies에 새로운 값이 담긴 상태일테니까 tableView.reloadData() 하면 됨.
                self.tableView.reloadData()
                self.navigationItem.title = notification.userInfo?["title"] as? String
            case .Failure(let errorType):
                self.showErrorAlert(errorType: errorType)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//tableView datasource, delegate
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
