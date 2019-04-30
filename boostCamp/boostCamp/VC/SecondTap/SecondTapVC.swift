//
//  SecondTapVC.swift
//  boostCamp
//
//  Created by 강수진 on 2018. 12. 12..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SecondTapVC: UIViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //노티 설정
        NotificationCenter.default.addObserver(self, selector: #selector(getMovieStatusInfo(_:)), name: MOVIE_STATUS_NOTI, object: nil)
        setupCollectionView()
        setFirstData()
    }
    
    @IBAction func settingAction(_ sender: Any) {
        orderAction { (orderType) in
            DataCenter.shared().selectedOrder = orderType
            self.activityIndicator.startAnimating()
        }
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(startReload(_:)), for: .valueChanged)
    }
    
    @objc func startReload(_ sender: UIRefreshControl){
        DataCenter.shared().selectedOrder = DataCenter.shared().selectedOrder
    }
    
    func setFirstData(){
        DataCenter.shared().selectedOrder = DataCenter.shared().selectedOrder
        self.activityIndicator.startAnimating()
    }
    
    //노티 받아서 실행될 함수
    @objc func getMovieStatusInfo(_ notification : Notification) {
        if let status = (notification.userInfo?["status"] as? NetworkResult<Movies>){
            self.activityIndicator.stopAnimating()
            collectionView.refreshControl?.endRefreshing()
            switch status {
            case .Success(_):
                self.collectionView.reloadData()
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

//collectionView datasource, delegate
extension SecondTapVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataCenter.shared().movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondTapCVCell.reuseIdentifier, for: indexPath) as! SecondTapCVCell
        guard DataCenter.shared().movies.count > 0 else {return cell}
        cell.configure(data: DataCenter.shared().movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier:DetailVC.reuseIdentifier) as? DetailVC {
            detailVC.selectedMovie = DataCenter.shared().movies[indexPath.row].id
            detailVC.selectedMovieTitle = DataCenter.shared().movies[indexPath.row].title
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension SecondTapVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.getPortionalLength(), height: 250.getPortionalLength())
    }
}


