
import UIKit

let str = "선택 "

private func checkNamePolicy(texts: String) -> Bool {
    print("0")
    // String -> Array
    let text = String(texts.last!)
    let arr = Array(text)
    // 정규식 pattern. 한글, 영어, 숫자, 밑줄(_)만 있어야함
    let pattern = "[ㄱ-ㅎㅏ-ㅣ]"
    if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
        var index = 0
        while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
            let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
            if results.count == 0 {
                return false
            } else {
                index += 1
            }
        }
    }
    return true
}

private func checkSpecialPolicy(text: String.Element) -> Bool {
    print("0")
    // String -> Array
    let text = String(text)
    let arr = Array(text)
    // 정규식 pattern. 한글, 영어, 숫자, 밑줄(_)만 있어야함
    let pattern = "^[_]$"
    if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
        var index = 0
        while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
            let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
            if results.count == 0 {
                return false
            } else {
                index += 1
            }
        }
    }
    return true
}

func postPositionText(_ name: String) -> Bool {
    print("1")
    guard let text = name.last else { return false }
    if checkSpecialPolicy(text: text) {
        return false
    }
    print("z\(text)z")
    let val = UnicodeScalar(String(text))?.value
    print("2")
    guard let value = val else { return false }
    print("3")
    let x = (value - 0xac00) / 28 / 21
    
    let y = ((value - 0xac00) / 28) % 21
    
    let z = (value - 0xac00) % 28
    print("4")
    if z == 0 {
        //받침이 없음
        return true
    } else {
        return false
    }
}


if checkNamePolicy(texts: str) {
    //완전한 문자가 아님
    print(str)
} else {
    let strPlus = postPositionText(str) ? "계속" : "멈춰"
    print(strPlus)
}

