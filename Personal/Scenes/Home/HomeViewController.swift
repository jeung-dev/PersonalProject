//
//  ViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/09/23.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    //해당 프로토콜에서는 화면에 데이터를 바인딩 시켜주는 일을 한다.
}

class HomeViewController: BaseViewController, HomeDisplayLogic {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    let category: [Home.Category] = [Home.Category.KakaoLogin,
                                     Home.Category.KakaoMap,
                                     Home.Category.RestfulApi,
                                     Home.Category.PopupVC,
                                     Home.Category.NoticeBoard,
                                     Home.Category.Localization,
                                     Home.Category.UseKeyChain]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    func setup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNoticeBoard" {
            
        } else if segue.identifier == "toSub" {
            router!.routeToSub(segue: segue)
        } else if segue.identifier == "toUseKeyChain"{
            router
        }
        
    }

}

//MARK: TableView Extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeTableViewCell else { return UITableViewCell()}
        cell.categoryLabel.text = self.category[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        //서브뷰에 해당 카테고리를 넘겨주기 위한 작업 (추후 router에서 쓰임)
        let category = category[indexPath.row]
        
        //다음 화면이 무엇인지에 따라 다른 작업
        switch category {
            
        case .NoticeBoard:
            
            performSegue(withIdentifier: "toNoticeBoard", sender: nil)
            break
        case .Localization:
            performSegue(withIdentifier: "Localization", sender: nil)
            break
        case .UseKeyChain:
            performSegue(withIdentifier: "toUseKeyChain", sender: nil)
            
        default:    //SubViewController
            
            //카테고리 이름을 넘겨서 SubViewController에서 화면을 분기함
            interactor?.setCategory(category)
            performSegue(withIdentifier: "toSub", sender: nil)
            
            
            break
            
        }
        
        return indexPath
    }
    
    
}

//MARK: Accessibility
extension HomeViewController: DynamicTypeable {
    func setLabelFontStyle() {
    }
}
