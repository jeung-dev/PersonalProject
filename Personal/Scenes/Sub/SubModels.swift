//
//  SubModels.swift
//  Personal
//
//  Created by 으정이 on 2021/09/29.
//

import Foundation

enum Sub {
    
    enum FetchData {
        struct Covid19 {
            var id: Int?  //예방 접종 센터 고유 식별자
            var facilityName: String?  //시설명
            var address: String?    //주소
            var updatedAt: String?
            var createdAt: String?
            var centerName: String?  //예방 접종 센터 명
            var sido: String?  //시도
            var sigungu: String?    //시군구
            var zipCode: String?    //우편번호
            var lat: String?    //좌표(위도)
            var lng: String?    //좌표(경도)
            var centerType: String?  //예방 접종 센터 유형
            var org: String?    //운영기관
            var phoneNumber: String?    //사무실 전화번호
        }
        
        struct UserInfo {
            var nickname: String?
            var profileImageUrl: URL?
            var thumbnailImageUrl: URL?
        }
    }
}
