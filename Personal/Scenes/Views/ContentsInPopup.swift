//
//  ContentsInPopup.swift
//  Personal
//
//  Created by 으정이 on 2021/09/29.
//

import UIKit

class ContentsInPopup: UIView {
    
    @IBOutlet weak var contentsView: UIView!
    
    let contentView2: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = UIImageView()
    
    let imsiView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func loadViewFromNib() -> ContentsInPopup? {
        let name = String(describing: self)
        guard let loadedNib = Bundle.main.loadNibNamed(name, owner: self, options: nil) else { return nil }
        guard let contentsInPopup = loadedNib.first as? ContentsInPopup else { return nil }
        return contentsInPopup
    }
    
    func setRect(_ height: CGFloat) {
        // 안에 있는 컨텐츠의 높이를 정함
        contentView2.frame.size.height = height
        contentView2.frame.size.width = self.contentsView.frame.width
        self.contentsView.addSubview(contentView2)
        
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        contentView2.topAnchor.constraint(equalTo: self.contentsView.topAnchor).isActive = true
        contentView2.leadingAnchor.constraint(equalTo: self.contentsView.leadingAnchor).isActive = true
        contentView2.bottomAnchor.constraint(equalTo: self.contentsView.bottomAnchor).isActive = true
        
    }
    
    func setImsiView(_ callback: callback) {
        imsiView.frame.size = CGSize(width: self.contentsView.frame.width, height: 300)
        self.contentsView.addSubview(imsiView)
        callback()
    }
    
    func removeImsiView() {
        imsiView.removeFromSuperview()
    }
    
    func setImage(_ img: UIImage, callback: callback) {
        
        guard let resizingImg = img.resizeImageByKeepingAspectRatio(img, toWidth: self.contentsView.frame.width) else {
            Logger.d("이미지 리사이징에 실패함.")
            return
        }
        Logger.d(resizingImg)
        self.imageView.image = resizingImg
        self.imageView.backgroundColor = .lightGray
        //사이즈를 화면 크기에 맞춤 비율을 그대로 가야할 것 같음
        contentView2.removeFromSuperview()
        self.contentsView.addSubview(imageView)
        
        
        self.imageView.frame.size = resizingImg.size
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: self.contentsView.topAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: self.contentsView.leadingAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: self.contentsView.bottomAnchor)])
        callback()
    }
    
}
