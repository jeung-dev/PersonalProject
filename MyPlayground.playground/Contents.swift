
import UIKit

//여러 뷰를 합치는 메서드
func combineT(_ views: [PopupView], padding: CGFloat?) -> UIView {
    let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    let backV = UIView(frame: rect)
    backV.backgroundColor = .lightGray
    let _padding: CGFloat = padding ?? 30
    
    //추가
    for v in views {
        backV.addSubview(v.body)
    }
    
    //frame 조절
    var preView: UIView = backV
    var count = 0
    //Logger.d("subViews: \(backV.subviews)")
    //잘 뽑아짐. 대신에 해당하는 view가 하나도 없으면 nil이 아닌 []로 리턴됨.
    let limitHeightContents = views.filter { popupView in
        return popupView.part == .content && popupView.body.frame.size.height > 400
    }
//    Logger.d("높이가 400 이상인 view: \(a.debugDescription)")
    if limitHeightContents.count > 0 {
//        Logger.d("잘들어옴?") //ㅇㅇ 들어옴
        for limitView in limitHeightContents {
            limitView.body.frame.size.height = 200
        }
    }
    
    for subV in backV.subviews {
        if count == 0 {
            subV.frame.origin.x = _padding
            subV.frame.origin.y = preView.frame.origin.y
            count += 1
        } else {
            subV.frame.origin.x = _padding
            subV.frame.origin.y = preView.frame.origin.y + preView.frame.size.height + _padding
            count += 1
        }
        preView = subV
    }
    
    //subViews의 높이가 backV보다 큰 경우 처리
    //컨텐츠 영역만 스크롤이 되게 해야함.
    //각 영역이 무슨 영역인지 알아야 하고
        //OK
    //컨텐츠 영역은 특정 높이가 넘지 않도록 한다.
    //그리고 컨텐츠 뷰를 만드는 곳에서 스크롤이 들어가게 하면 된다.
    
    

    return backV
}

struct PopupView {
    enum Part {
        case quitButton
        case title
        case content
        case confirmButton
    }
    
    var body: UIView
    var part: Part
    
    init(_ body: UIView, part: Part) {
        self.body = body
        self.part = part
    }
    
}

let v1 = PopupView(UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100)), part: .quitButton)
v1.body.backgroundColor = .red
let v2 = PopupView(UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200)), part: .title)
v2.body.backgroundColor = .orange
let v3 = PopupView(UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 500)), part: .content)
v3.body.backgroundColor = .yellow
let v4 = PopupView(UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300)), part: .confirmButton)
v4.body.backgroundColor = .green
let v5 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
v5.backgroundColor = .blue

let combineV = combineT([v1,v2,v3,v4], padding: 10)
