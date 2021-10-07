//
//  SubWorker.swift
//  Personal
//
//  Created by 으정이 on 2021/10/07.
//

import Foundation
import Alamofire
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

public typealias UserDataHandler = (User?) -> Void
class SubWorker {
    
    public init() {
        
    }
    
    
    /// 기본 헤더 설정
    private var headers: HTTPHeaders {
        [.contentType("application/x-www-form-urlencoded"),
         .accept("application/json"),
         .authorization("Infuser m+AB97QjVAk8g8IGN9PTm5H+dfLsRRkZVWVXfhPqgvcko5uRCLo7ai4ak/S57jyNOqKLxq7xiDzPRyUqDrQbZw==")]
    }
    
    
    /// Covid19 데이터를 받는다
    /// - Parameters:
    ///   - page: <#page description#>
    ///   - perPage: <#perPage description#>
    ///   - jsonResultHandler: JSON 결과를 리턴하는 handler
    public func fetchData(page: String, perPage: String, jsonResultHandler: @escaping JSONResultHandler) {
        let const = NetworkAPI.Centers.default
        let params: [String:Any] = ["page":page,
                                    "perPage":perPage,
                                    "returnType":"json"]
        NetworkAPI.shared.request(reqConst: const, params: params, headers: headers, jsonResultHandler: jsonResultHandler)
    }
    
}
