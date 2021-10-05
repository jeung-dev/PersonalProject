//
//  MyTestViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/10/04.
//

import UIKit

class MyTestViewController: UIViewController {
    let sampleView: UIView = {
       let v = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        v.backgroundColor = .green
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(sampleView)
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .layoutSubviews, animations: {
            self.sampleView.frame.size.height = 300
        }, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
