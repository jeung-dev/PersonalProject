
import UIKit
import PlaygroundSupport

class TestViewController: UIViewController {
    let textFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.backgroundColor = .gray
        return textFiled
    }()
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        textFiled.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        button.frame = CGRect(x: 0, y: 60, width: 50, height: 50)
        print("?????")
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpOutside)
        
        self.view.addSubViews([textFiled, button])
        presentAlert(title: "얼럿", message: "얼럿뜨나?", actionTitle: "확인")
    }
    
    @objc func buttonPressed() {
        print(self.textFiled.text ?? "")
        
        
        
    }
    
    func presentAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension TestViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("!!!!!!")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("??????")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        
        return true
    }
}
let viewController = TestViewController()

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = viewController

/**
 # view update 확인하기
 */


