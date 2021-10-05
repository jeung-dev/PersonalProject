//
//  PopupInteractor.swift
//  Personal
//
//  Created by 으정이 on 2021/10/04.
//

import Foundation
import UIKit

protocol PopupBusinessLogic {
    var dataStore: Popup? { get }
}
protocol PopupDataStore {
    var dataStore: Popup? { get set }
}
class PopupInteractor: PopupBusinessLogic, PopupDataStore {
    var dataStore: Popup?
    var presenter: PopupPresenter?
}
