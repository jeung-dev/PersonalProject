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
    
    
    /// 카톡 설치 여부에 따라서 분기함
    private func needKakaoLogin() {
        //카카오톡 설치여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if error != nil {
                    Logger.d(error as Any)
                } else {
                    Logger.d("loginWithKakaoTalk() success.")
                    
                    //do something
                    KAKAO_OAUTH_TOKEN = "\(oauthToken!)"
                    Logger.d(KAKAO_OAUTH_TOKEN)
                }
            }
        } else {
            //카카오톡 설치가 안 되어 있으므로 인터넷으로 로그인
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if error != nil {
                    Logger.d(error as Any)
                } else {
                    Logger.d("loginWithKakaoTalk() success.")
                    
                    //do something
                    KAKAO_OAUTH_TOKEN = "\(oauthToken!)"
                    Logger.d(KAKAO_OAUTH_TOKEN)
                }
            }
        }
    }
    
    
    /// 토큰 여부에 따라서 분기함
    /// - Parameter completionHandler: User 데이터를 포함한 Handler
    public func kakaoLogin(completionHandler: @escaping UserDataHandler) {
        //토큰 존재 여부 확인
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                
                if error != nil {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        //로그인 필요
                        self.needKakaoLogin()
                    } else {
                        //기타 에러 -- 문서에 따라 각 처리 필요
                        Logger.d(error as Any)
                    }
                } else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    self.kakaoUserInfo(completionHandler: { user in
                        completionHandler(user)
                    })
                }
            }
        } else {
            //토큰이 존재하지 않으므로 로그인 필요
            needKakaoLogin()
        }
    }
    
    
    /// 사용자 정보를 가져오는 메서드
    /// - Parameter completionHandler: User 데이터를 포함한 Handler
    private func kakaoUserInfo(completionHandler: @escaping UserDataHandler) {
        UserApi.shared.me { user, error in
            if error != nil {
                Logger.d(error as Any)
            } else {
                Logger.d("me() success.")
                //do something
                Logger.i(user as Any)
                completionHandler(user)
            }
        }
    }
    
}
