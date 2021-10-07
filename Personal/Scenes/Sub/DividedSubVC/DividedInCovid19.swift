//
//  DividedInCovid19.swift
//  Personal
//
//  Created by 으정이 on 2021/10/07.
//

import UIKit

//MARK: Covid19ViewController
extension SubViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eachData = self.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataEachTableViewCell", for: indexPath) as? DataEachTableViewCell
        
        //각 데이터 있는지 확인
        guard let address = eachData.address, let facilityName = eachData.facilityName, let updatedAt = eachData.updatedAt else {
            return cell!
        }
        cell?.addressLabel?.text = "주소: \(address)"
        cell?.facilityNameLabel?.text = "\(facilityName)"
        cell?.facilityNameLabel?.setAsMainTitle()
        cell?.updatedAtLabel?.attributedText = "업데이트 일자: \(updatedAt)".strikeThrough()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //        Logger.i("data Cout : \(self.data.count)")
        for indexPath in indexPaths {
            //            Logger.d("indexPath row : \(indexPath.row)")
            if data.count - 1 == indexPath.row {
                self.pagingNum += 1
                self.fetchDataFromServer("\(self.pagingNum)")
            }
        }
    }
    
    @objc func refresh() {
        self.data.removeAll()
        self.pagingNum = 0
        self.tableView.reloadData()
    }
    
    /// 데이터 업데이트
    /// - Parameter pagingNum: 페이지 번호
    func fetchDataFromServer(_ pagingNum: String) {
        self.startLoadingIndicator()
        interactor?.fetchCovid19DataFromServer(page: "\(self.pagingNum)", perPage: "20")
    }
    
    
    /// 새로 받아온 데이터를 화면에 띄움
    /// - Parameter data: 새로 받아온 데이터
    func displayFetchedCovidData(data: [Sub.FetchData.Covid19]) {
        self.data = data
        self.tableView.reloadData()
        self.stopLoadingIndicator()
    }
    
    
    /// SubViewController 화면을 Setting한다.
    /// Type: RestfulApi
    func setupForRestfulApiDATA() {
        
        //TableView Setting
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "DataEachTableViewCell", bundle: nil), forCellReuseIdentifier: "DataEachTableViewCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100//UITableView.automaticDimension
        
        self.tableView.prefetchDataSource = self
        self.tableView.refreshControl = self.refreshControl
        let refreshAction = UIAction { action in
            self.data.removeAll()
            self.pagingNum = 0
            self.tableView.reloadData()
        }
        if #available(iOS 14.0, *) {
            self.refreshControl.addAction(refreshAction, for: .valueChanged)
        } else {
            // Fallback on earlier versions
            self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        }
        
        //Indicator
        overrideUserInterfaceStyle = .light
        
        //Add Views
        self.view.addSubViews([tableView])
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        //Data Setting
        self.fetchDataFromServer("\(self.pagingNum)")
    }
    
    
}
