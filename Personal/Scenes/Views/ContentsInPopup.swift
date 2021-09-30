//
//  ContentsInPopup.swift
//  Personal
//
//  Created by 으정이 on 2021/09/29.
//

import UIKit

class ContentsInPopup: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
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
    
    func removeAllSubViews(){
            for subview in self.contentsView.subviews {
                subview.removeFromSuperview()
            }
        }

    func setItems(_ views: [UIView]) {
        
        //뷰들을 추가하기 전에 이전 뷰를 모두 지우자
        self.removeAllSubViews()
        
        //MARK: TODO 아이템 순서대로 띄우는 코드
        
        var preView: UIView?    //constraint top을 잡기 위한 이전 뷰
        let viewsCount = views.count    //마지막 뷰를 알기 위함
        var count = 0   //마지막 뷰를 알기 위함
        
        for view in views {
            
            //마지막 뷰를 알아채기 위한 카운트
            count += 1
            
            //크기받아오기
            let newView = self.getResizeByKeepingAspectRatioView(view, toWidth: UIScreen.main.bounds.width)
            
            //Add
            self.contentsView.addSubview(newView)   //추가하지 않으면 에러남 --> 조상이 없다는 문구가 있어서 contentView에 추가했더니 에러가 안남. 추후에 없애면 constraint가 이상해짐.
            self.contentsView.addSubview(view)
            
            //Constraint 조절
            view.translatesAutoresizingMaskIntoConstraints = false
            
            //만약 이전 뷰가 없으면 첫번째 뷰임.
            if preView == nil {
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor),
                    view.topAnchor.constraint(equalTo: view.superview!.topAnchor),
                    view.trailingAnchor.constraint(equalTo: view.superview!.trailingAnchor),
                    view.heightAnchor.constraint(equalTo: newView.heightAnchor)
                ])
                preView = view
            } else {
                //마지막 뷰일 때, bottomAnchor 정하기
                if count != viewsCount {
                    NSLayoutConstraint.activate([
                        view.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor),
                        view.topAnchor.constraint(equalTo: preView!.bottomAnchor),
                        view.trailingAnchor.constraint(equalTo: view.superview!.trailingAnchor),
                        view.heightAnchor.constraint(equalTo: newView.heightAnchor)
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        view.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor),
                        view.topAnchor.constraint(equalTo: preView!.bottomAnchor),
                        view.trailingAnchor.constraint(equalTo: view.superview!.trailingAnchor),
                        view.bottomAnchor.constraint(equalTo: view.superview!.bottomAnchor),
                        view.heightAnchor.constraint(equalTo: newView.heightAnchor)
                    ])
                }
                preView = view
            }
        }
        scrollView.updateContentView()  //scrollView 높이 재정의(뷰들의 높이에 맞춤)
        self.imageView.removeFromSuperview()    //스켈레톤을 띄우던 이미지뷰 삭제
    }
    
    func getResizeByKeepingAspectRatioView(_ source: UIView, toWidth: CGFloat) -> UIView {
        let oldWidth = source.frame.size.width
        let scaleFactor = toWidth / oldWidth
        let newHeight = source.frame.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let rect = CGRect(origin: .zero, size: newSize)
        let view = UIView(frame: rect)
        return view
    }
    
}
