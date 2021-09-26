
import UIKit

//MARK: Extension
extension UIView {
    func addSubViews(_ views: [Any]) {
        for v in views {
            if v is UIImageView {
                self.addSubview(v as! UIImageView)
            }
            else if v is UILabel {
                self.addSubview(v as! UILabel)
            }
            else if v is UIButton {
                self.addSubview(v as! UIButton)
            }
            else if v is UIView {
                self.addSubview(v as! UIView)
            }
        }
    }
}

//MARK: Combine All Views
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
        //OK
    //그리고 컨텐츠 뷰를 만드는 곳에서 스크롤이 들어가게 하면 된다.
        //MARK: TODO
    
    

    return backV
}

//MARK: Contents Make

enum ContentType {
    case View
    case ImageView
    case Label
}

enum CustomError: Error {
    case contentViewIsNotRight
}

struct OrderContent {
    var type: ContentType?
    var content: Any?
    var rect: CGRect?
    init(type t: ContentType, content c: Any, rect r: CGRect) {
        self.type = t
        self.content = c
        self.rect = r
    }
}

//컨텐츠뷰를 합쳐서 하나의 뷰로 만드는 메서드
//컨텐츠뷰는 스크롤되어야 한다.
//컨텐츠뷰는 특정 높이 이상이 될 수 없다.
//이 높이는 고정되어 있지 않다. 추후 뷰를 합칠 때 달라 질 수 있다.
func getCombineContents(contents: [OrderContent]?) -> UIView {
    
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .green
    scrollView.isScrollEnabled = true
    let viewWidth = UIScreen.main.bounds.width * 0.9
    var height: CGFloat = 0
//        CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
    let contentView = UIView()
//    contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    //컨텐츠의 종류에 따라 view에서의 위치가 다름
    //같은 종류의 컨텐츠가 여러개 들어왔을 경우도 생각해야 함
    //컨텐츠가 아애 없을 수도 있음
    
    //컨텐츠가 있는지 확인
    guard let _contents = contents else {
        //없으면 초기설정만 한 view 리턴
        contentView.addSubview(scrollView)
        contentView.frame.size.width = viewWidth
        contentView.frame.size.height = height
        return contentView
    }
    
    //컨텐츠의 종류에 따라 순서에 맞춰 view에 추가
    let viewOrders = _contents.filter { content in
        return content.type == .View
    }
    let views: [Any] = {
        var vs: [Any] = []
        for v in viewOrders {
            vs.append(v.content!)
        }
        return vs
    }()
    scrollView.addSubViews(views)
    
    let imageViewOrders = _contents.filter { content in
        return content.type == .ImageView
    }
    let imageViews: [Any] = {
        var ivs: [Any] = []
        for iv in imageViewOrders {
            ivs.append(iv.content!)
        }
        return ivs
    }()
    scrollView.addSubViews(imageViews)
    
    let labelOrders = _contents.filter { content in
        return content.type == .Label
    }
    let labels: [Any] = {
        var ls: [Any] = []
        for l in labelOrders {
            ls.append(l.content!)
        }
        return ls
    }()
    scrollView.addSubViews(labels)
    
    //Contraint 지정
    //SnapKit 사용하지 않고 하기
    for viewOrder in viewOrders {
        height = makeConstraint(sourceWidth: viewWidth, order: viewOrder, yPoint: height + 5)
    }
    
    for imgViewOrder in imageViewOrders {
        height = makeConstraint(sourceWidth: viewWidth, order: imgViewOrder, yPoint: height + 5)
    }
    
    for labelOrder in labelOrders {
        height = makeConstraint(sourceWidth: viewWidth, order: labelOrder, yPoint: height + 5)
    }
    
    //content의 크기에 따라 view의 height정함
    contentView.addSubview(scrollView)
    let someHeight: CGFloat = 400
    if height > someHeight {
        
        scrollView.frame.size.width = viewWidth
        scrollView.frame.size.height = someHeight
        contentView.frame.size.width = viewWidth
        contentView.frame.size.height = someHeight
    } else {
        
        scrollView.frame.size.width = viewWidth
        scrollView.frame.size.height = someHeight
        contentView.frame.size.width = viewWidth
        contentView.frame.size.height = someHeight
    }
    
    
    
    //각 종류별로 크기 변경
    return contentView
}

//source에 추가했다고 가정
//content의 width가 있다고 가정
//content의 height가 있다고 가정
//endPoint를 return함
func makeConstraint(sourceWidth: CGFloat, order: OrderContent, yPoint y: CGFloat) -> CGFloat{
    guard let width = order.rect?.width, let height = order.rect?.height else {
        return y
    }
    
    let leading = (sourceWidth - width) / 2
    
    switch order.type {
    case .ImageView:
        let imgView = order.content as! UIImageView
        imgView.frame.origin.y = y
        imgView.frame.origin.x = leading
        imgView.frame.size.width = width
        imgView.frame.size.height = height
        return y + height
    case .Label:
        let label = order.content as! UILabel
        label.frame.origin.y = y
        label.frame.origin.x = leading
        label.frame.size.width = width
        label.frame.size.height = height
        return y + height
    case .View:
        let view = order.content as! UIView
        view.frame.origin.y = y
        view.frame.origin.x = leading
        view.frame.size.width = width
        view.frame.size.height = height
        return y + height
    case .none:
        return y
    }
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

//let v1 = PopupView(UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100)), part: .quitButton)
//v1.body.backgroundColor = .red
//let v2 = PopupView(UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200)), part: .title)
//v2.body.backgroundColor = .orange
//let v3 = PopupView(UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 500)), part: .content)
//v3.body.backgroundColor = .yellow
//let v4 = PopupView(UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300)), part: .confirmButton)
//v4.body.backgroundColor = .green
//let v5 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
//v5.backgroundColor = .blue
//
//let combineV = combineT([v1,v2,v3,v4], padding: 10)


let view = UIView()
view.backgroundColor = UIColor.yellow
let viewOrder: OrderContent = OrderContent(type: .View, content: view, rect: CGRect(x: 0, y: 0, width: 300, height: 300))

let imageView = UIImageView()
imageView.contentMode = .scaleAspectFit
imageView.image = UIImage(named: "Logo")
imageView.backgroundColor = .blue
let imageViewOrder: OrderContent = OrderContent(type: .ImageView, content: imageView, rect: CGRect(x: 0, y: 0, width: 300, height: 400))

let label = UILabel()
label.backgroundColor = UIColor.red
label.text = "안녕하세요"
let labelOrder: OrderContent = OrderContent(type: .Label, content: label, rect: CGRect(x: 0, y: 0, width: 300, height: 50))



let resultView = getCombineContents(contents: [viewOrder, labelOrder, imageViewOrder])

/*
import UIKit
import SnapKit



class PopupMaker {
    
    /// 버튼들을 관리할 구조체
    /// 버튼은 각 order마다 하나씩만 넣을 수 있음
    struct Buttons {
        
        enum ButtonType {
            case cancel
            case `default`
            case destructive
        }
        
        struct Button {
            
            enum Oder: Int {
                case first = 0
                case second
                case third
            }
            var body: UIButton
            var type: ButtonType
            var order: Oder
            var text: String
            
            init(body: UIButton, type: ButtonType, order: Oder, text: String?) {
                self.body = body
                self.type = type
                self.order = order
                self.text = text ?? ""
                //setup
                self.body.setTitle(self.text, for: .normal)
                
            }
            
            func event(_ target: Any, action: Selector, event: UIControl.Event) {
                body.addTarget(target, action: action, for: event)
            }
            
        }
        
        var count: Int = 0
        let height: CGFloat = 50
        var width: CGFloat
        var first: Buttons.Button?
        var second: Buttons.Button?
        var third: Buttons.Button?
        
        init(_ buttons: [Buttons.Button]) {
            for btn in buttons {
                if first == nil, btn.order == .first {
                    first = btn
                    count += 1
                }
                if second == nil, btn.order == .second {
                    second = btn
                    count += 1
                }
                if third == nil, btn.order == .third {
                    third = btn
                    count += 1
                }
            }
            self.width = UIScreen.main.bounds.width/CGFloat(self.count)
            
            //Logger.d("fb: \(first), sb: \(second), tb: \(third), count: \(count), height: \(height), width: \(width)")
            
        }
        
    }
    
    enum ContentType {
        case View
        case ImageView
        case Label
    }

    enum CustomError: Error {
        case contentViewIsNotRight
    }

    struct OrderContent {
        var type: ContentType?
        var content: Any?
        var rect: CGRect?
        init(type t: ContentType, content c: Any, rect r: CGRect) {
            self.type = t
            self.content = c
            self.rect = r
        }
    }
    
    /// DimmedView를 리턴하는 메서드
    /// - Returns: DimmedView
    func getDimmedView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }
    
    /// QuitButton을 리턴하는 메서드
    /// - Returns: QuitButton
    func getQuitButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "quit"), for: .normal)
        button.backgroundColor = UIColor.red    //실제 사용할 때는 삭제
        return button
    }
    
    
    /// Title을 리턴하는 메서드
    /// - Parameters:
    ///   - text: title Text
    ///   - rect: title Rect
    /// - Returns: Title Label
    func getTitle(_ text: String, rect: CGRect) -> UILabel {
        let label = UILabel(frame: rect)
        let attributes: [NSAttributedString.Key : Any] = [.font : UIFont.boldSystemFont(ofSize: 20)]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.backgroundColor = UIColor.red
        return label
    }
    
    /// 3개의 버튼을 받아서 순서에 맞게 view에 추가하고 크기를 조정하여 view를 리턴하는 메서드
    /// 고정값: 버튼 높이, 버튼 최대 개수
    /// 유동값: 버튼 색, 버튼 Font, 버튼 이벤트, 버튼 width(개수에 따라 나눠서 정해짐), 버튼 Text, 버튼의 순서
    /// - Parameter buttons: 3개의 버튼이 있는 구조체
    /// - Returns: 버튼이 추가된 view
    func getButtonView(_ buttons: Buttons) -> UIView {
//        Logger.i(buttons)
        let width = buttons.width * CGFloat(buttons.count)
//        Logger.i(width)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: buttons.height))
        view.backgroundColor = .green
        var preBtn: Buttons.Button?
        var nxtBtn: Buttons.Button?
        //버튼 3개를 만들어서 순서를 정해서 view에 추가
        if buttons.count > 0 {
            view.snp.makeConstraints { make in
                //width, height
                make.width.equalTo(width)
                make.height.equalTo(buttons.height)
            }
        }
        if let btn1 = buttons.first {
            view.addSubview(btn1.body)
            preBtn = btn1
            nxtBtn = buttons.second ?? buttons.third
            
            btn1.body.snp.makeConstraints { make in
                //width, height
                make.width.equalTo(buttons.width)
                make.height.equalTo(buttons.height)
                
                //top, bottom
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                
                //leading
                make.leading.equalToSuperview()
                
                //trailing
                if nxtBtn != nil {
//                    Logger.d("???")
                    //nxtBtn에서 leading을 정함
                } else {
//                    Logger.d("????????")
                    make.trailing.equalToSuperview()
                }
            }
        }
        if let btn2 = buttons.second {
            view.addSubview(btn2.body)
            preBtn = buttons.first
            nxtBtn = buttons.third
            
            btn2.body.snp.makeConstraints { make in
                //width, height
                make.width.equalTo(buttons.width)
                make.height.equalTo(buttons.height)
                
                //top, bottom
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                
                //leading
                if let _preBtn = preBtn {
                    make.leading.equalTo(_preBtn.body.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
                //trailing
                if nxtBtn != nil {
                    //nxtBtn에서 leading을 정함
                } else {
                    make.trailing.equalToSuperview()
                }
            }
        }
        if let btn3 = buttons.third {
            view.addSubview(btn3.body)
            preBtn = buttons.second ?? buttons.first
            nxtBtn = nil
            
            btn3.body.snp.makeConstraints { make in
                //width, height
                make.width.equalTo(buttons.width)
                make.height.equalTo(buttons.height)
                
                //top, bottom
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                
                //leading
                if let _preBtn = preBtn {
                    make.leading.equalTo(_preBtn.body.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
                //trailing
                make.trailing.equalToSuperview()
            }
        }
        
        return view
    }
    
    
    //뒤에 Dimmed 처리를 해야함. -- 지워야 함
    func createContentView(contents: [OrderContent]?) -> UIView {
        
        let padding: CGFloat = 50
        let viewWidth = UIScreen.main.bounds.width * 0.9
        var height: CGFloat = padding
//        CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
        let contentView = UIView()
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //컨텐츠의 종류에 따라 view에서의 위치가 다름
        //같은 종류의 컨텐츠가 여러개 들어왔을 경우도 생각해야 함
        //컨텐츠가 아애 없을 수도 있음
        
        //컨텐츠가 있는지 확인
        guard let _contents = contents else {
            //없으면 초기설정만 한 view 리턴
            contentView.snp.makeConstraints { make in
                make.width.equalTo(viewWidth)
                make.height.equalTo(height)
            }
            return contentView
        }
        
        //컨텐츠의 종류에 따라 순서에 맞춰 view에 추가
        let viewOrders = _contents.filter { content in
            return content.type == .View
        }
        let views: [Any] = {
            var vs: [Any] = []
            for v in viewOrders {
                vs.append(v.content!)
            }
            return vs
        }()
        contentView.addSubViews(views)
        
        let imageViewOrders = _contents.filter { content in
            return content.type == .ImageView
        }
        let imageViews: [Any] = {
            var ivs: [Any] = []
            for iv in imageViewOrders {
                ivs.append(iv.content!)
            }
            return ivs
        }()
        contentView.addSubViews(imageViews)
        
        let labelOrders = _contents.filter { content in
            return content.type == .Label
        }
        let labels: [Any] = {
            var ls: [Any] = []
            for l in labelOrders {
                ls.append(l.content!)
            }
            return ls
        }()
        contentView.addSubViews(labels)
        
        //Contraint 지정
        for viewOrder in viewOrders {
            height = makeConstraint(sourceWidth: viewWidth, order: viewOrder, yPoint: height + 5)
        }
        
        for imgViewOrder in imageViewOrders {
            height = makeConstraint(sourceWidth: viewWidth, order: imgViewOrder, yPoint: height + 5)
        }
        
        for labelOrder in labelOrders {
            height = makeConstraint(sourceWidth: viewWidth, order: labelOrder, yPoint: height + 5)
        }
        
        //content의 크기에 따라 view의 height를 padding 추가하여 바꿈
        contentView.snp.makeConstraints { make in
            make.width.equalTo(viewWidth)
            make.height.equalTo(height + padding)
//            make.center.equalTo(center)
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview()
        }
        
        //각 종류별로 크기 변경
        return contentView
    }

    //source에 추가했다고 가정
    //content의 width가 있다고 가정
    //content의 height가 있다고 가정
    //endPoint를 return함
    func makeConstraint(sourceWidth: CGFloat, order: OrderContent, yPoint y: CGFloat) -> CGFloat{
        guard let width = order.rect?.width, let height = order.rect?.height else {
            return y
        }
        
        let leading = (sourceWidth - width) / 2
        
        switch order.type {
        case .ImageView:
            let imgView = order.content as! UIImageView
            imgView.snp.makeConstraints { make in
                make.top.equalTo(y)
                make.leading.equalTo(leading)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            return y + height
        case .Label:
            let label = order.content as! UILabel
            label.snp.makeConstraints { make in
                make.top.equalTo(y)
                make.leading.equalTo(leading)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            return y + height
        case .View:
            let view = order.content as! UIView
            view.snp.makeConstraints { make in
                make.top.equalTo(y)
                make.leading.equalTo(leading)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            return y + height
        case .none:
            return y
        }
    }
    
    //입력된 모든 뷰를 합치는 뷰 - 세로
    //순서대로 온다고 가정
    //Dimmed뷰는 여기서 불러와야 함
    func combineViews(_ views: [UIView], _ padding: CGFloat?) -> UIView {
        let _padding = padding ?? 5
        
        let result = getDimmedView()
        //한계 height
        let limitHeight = UIScreen.main.bounds.height * 0.8
        result.addSubViews(views)
        
        var height: CGFloat = 0
        var prev: UIView?
        for v in views {
            v.translatesAutoresizingMaskIntoConstraints = false
            Logger.d(height)
            if prev == nil {
                v.snp.makeConstraints { make in
                    make.top.equalToSuperview()
//                    make.leading.equalToSuperview()
//                    make.trailing.equalToSuperview()
                    
                    make.center.equalToSuperview()
                    prev = v
                }
                
            } else {
                v.snp.makeConstraints { make in
//                    make.top.equalTo(prev!.snp.bottom)
                    make.top.equalTo(100)
//                    make.leading.equalToSuperview()
//                    make.trailing.equalToSuperview()
                    make.center.equalToSuperview()
                    prev = v
                }
                
            }
            
            let h = v.bounds.size.height
            height += h
        }
        
        if height > limitHeight {
            //한계 높이를 넘었을 경우
        } else {
//            result.snp.makeConstraints { make in
//                make.height.equalTo(height)
//            }
        }
        
        return result
    }

}


let popupMaker = PopupMaker()

//let dim = popupMaker.getDimmedView()
let quit = popupMaker.getQuitButton()
let title = popupMaker.getTitle("타이틀", rect: CGRect(x: 0, y: 0, width: 300, height: 30))
let btn1 = PopupMaker.Buttons.Button(body: UIButton(), type: .default, order: .first, text: "확인")
let btnM = PopupMaker.Buttons([btn1])
let buttons = popupMaker.getButtonView(btnM)
let v = UIView()
v.backgroundColor = .red
let cnt1 = PopupMaker.OrderContent(type: .View, content: v, rect: CGRect(x: 0, y: 0, width: 300, height: 300))
let cnts = popupMaker.createContentView(contents: [cnt1])

var combineViews: [UIView] = []
//combineViews.append(dim)
combineViews.append(quit)
combineViews.append(title)
combineViews.append(buttons)
//combineViews.append(cnts)
let popup = popupMaker.combineViews(combineViews, nil)
*/
