//
//  DividedInKakaoMap.swift
//  Personal
//
//  Created by 으정이 on 2021/10/08.
//

import Foundation


//MARK: KakaoMap
extension SubViewController{
    func creatMap() {
        let mapView = MTMapView(frame: self.view.frame)
//        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
    }
}
