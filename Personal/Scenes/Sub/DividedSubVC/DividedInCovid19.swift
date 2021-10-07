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
    
    func displayFetchedCovidData(data: [Sub.FetchData.Covid19]) {
        self.data = data
        self.tableView.reloadData()
        self.stopLoadingIndicator()
    }
    
    
}
