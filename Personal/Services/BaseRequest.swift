//
//  BaseRequest.swift
//  Personal
//
//  Created by 으정이 on 2021/10/07.
//

import Foundation
import Alamofire

class BaseRequest<T: Codable> {
    var api: NetworkAPI.ReqConstants? {
        nil
    }
    
    var url: String {
        if let api = api {
            return api.url
        }
        return NetworkAPI.host
    }
    
    var method: HTTPMethod {
        if let api = api {
            return api.method
        }
        return .post
    }
    
    var parameters: Parameters? {
        nil
    }
    
    var headers: HTTPHeaders {
        [.contentType("application/x-www-form-urlencoded"),
         .accept("application/json"), .authorization("Infuser m+AB97QjVAk8g8IGN9PTm5H+dfLsRRkZVWVXfhPqgvcko5uRCLo7ai4ak/S57jyNOqKLxq7xiDzPRyUqDrQbZw==")]
    }
}
