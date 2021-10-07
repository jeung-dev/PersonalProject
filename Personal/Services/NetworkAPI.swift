//
//  NetworkAPI.swift
//  Personal
//
//  Created by 으정이 on 2021/10/07.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias JSONResultHandler = (JSON?) -> Void

public struct NetworkAPI {

    // NSMall Server Mode!!!
    fileprivate static let mode: AppConfig.Variant = AppConfig.getVariant()

    // MARK: API Common
    static var host: String {

        switch mode {
        case .local:
            return "https://api.odcloud.kr/api/15077586/v1"
        case .dev:
            return "https://api.odcloud.kr/api/15077586/v1"
        case .test:
            return "https://api.odcloud.kr/api/15077586/v1"
        case .release:
            return "https://api.odcloud.kr/api/15077586/v1"
        }
    }

    typealias Completion = (_ response: Codable?, _ error: Error?) -> Void

    public struct ReqConstants {
        public let url: String
        public let method: HTTPMethod

        init(url: String, method: HTTPMethod) {
            self.url = url
            self.method = method
        }
    }
    
    enum Centers {

        static let `default` = ReqConstants(url: host + "/centers", method: .get)
    }

    // MARK: Alamofire Session
    public static let shared = NetworkAPI()

//    private let _session: Session = Session(interceptor: BaseRequestInterceptor())

    // MARK: Alamofire Session Request - Old version
    func request<T: Codable>(_ request: BaseRequest<T>, completion: @escaping Completion) -> DataRequest {
//        Logger.i("url: \(request.url), method: \(request.method), parameters: \(request.parameters!), encoding: \(URLEncoding.default), headers: \(request.headers)")
        return AF.request(request.url, method: request.method, parameters: request.parameters, encoding: URLEncoding.default, headers: request.headers)
                .validate(statusCode: 200..<300)
                .responseJSON(completionHandler: { (response) in
                    self.processing(request, response: response, completion: completion)
                })
    }

    private func processing<T: Codable>(_ request: BaseRequest<T>, response: AFDataResponse<Any>, completion: @escaping Completion) {
        switch response.result {
        case .success(let value):
//            Logger.i("request success")
            let data = try! JSONSerialization.data(withJSONObject: value)
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(response, nil)
            } catch let error {
                Logger.e("error parsing get logs: \(error)")
                completion(nil, error)
            }
        case .failure(let error):
            completion(nil, error)
        }
    }

    // MARK: Alamofire Session Request - New version
    public func request(reqConst: NetworkAPI.ReqConstants, params: [String : Any], headers: HTTPHeaders, jsonResultHandler: @escaping JSONResultHandler) {

//        debugPrint("URL = \(reqConst.url)")
//        debugPrint("PARAMS = \(params)")

            AF.request(
                reqConst.url,
                method:reqConst.method,
                parameters: params,
                headers: headers)
                .validate(statusCode: 200..<300)
                .response { resp in
                    let response: DataResponse<Data?, AFError>? = resp

                debugPrint(response?.error ?? "✅ No error!")
//                    debugPrint(String(bytes: response!.data!, encoding: .utf8))

                    if response?.error == nil, let data = response?.data, let dict = try? JSON(data: data) {
                        jsonResultHandler(dict)

                    } else {
                        jsonResultHandler(nil)
                    }
            }
        }

}

