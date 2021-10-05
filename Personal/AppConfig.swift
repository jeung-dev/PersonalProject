//
//  AppConfig.swift
//  Personal
//
//  Created by 으정이 on 2021/10/04.
//

import Foundation

enum AppConfig {

    enum Variant {
        case local
        case dev
        case test
        case release
    }

    static func getVariant() -> Variant {
#if DEBUG
//        return .local
//        return .dev
        return .test
#else
        return .dev
//        return .test
//        return .release
#endif
    }

}
