//
//  NoticeBoardInteractor.swift
//  Personal
//
//  Created by 으정이 on 2021/10/09.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NoticeBoardBusinessLogic
{
//  func doSomething(request: NoticeBoard.Something.Request)
}

protocol NoticeBoardDataStore
{
//  var name: String { get set }
}

class NoticeBoardInteractor: NoticeBoardBusinessLogic, NoticeBoardDataStore
{
  var presenter: NoticeBoardPresentationLogic?
//  var worker: NoticeBoardWorker?
  //var name: String = ""
  
  // MARK: Do something
  
//  func doSomething(request: NoticeBoard.Something.Request)
//  {
//    worker = NoticeBoardWorker()
//    worker?.doSomeWork()
//
//    let response = NoticeBoard.Something.Response()
//    presenter?.presentSomething(response: response)
//  }
}