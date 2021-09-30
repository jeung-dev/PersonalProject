//
//  ContentsInPopup.swift
//  Personal
//
//  Created by 으정이 on 2021/09/29.
//

import UIKit

class ContentsInPopup: UIView {
    
    @IBOutlet weak var contentsView: UIView!
    
    let imageView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        imgView.backgroundColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        return imgView
    }()
    
    static func loadViewFromNib() -> ContentsInPopup? {
        let name = String(describing: self)
        guard let loadedNib = Bundle.main.loadNibNamed(name, owner: self, options: nil) else { return nil }
        guard let contentsInPopup = loadedNib.first as? ContentsInPopup else { return nil }
        return contentsInPopup
    }
    
    func setImageView() {
        self.contentsView.addSubview(imageView)
    }
    
    func setImage(_ img: UIImage) {
        
        // ReSizing : 비율 유지, 화면 크기에 맞춤
        guard let resizingImg = img.resizeImageByKeepingAspectRatio(img, toWidth: self.contentsView.frame.width) else {
            Logger.d("이미지 리사이징에 실패함.")
            return
        }
        self.imageView.image = resizingImg
        self.imageView.frame.size = resizingImg.size
        
        
        //constraint
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentsView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentsView.leadingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentsView.bottomAnchor)
        ])
        
    }
    
    func setItems(_ views: [UIView]) {
        //MARK: TODO 아이템 순서대로 띄우는 코드
    }
    
}
