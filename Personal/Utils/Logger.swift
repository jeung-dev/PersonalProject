//
//  Logger.swift
//  Personal
//
//  Created by 으정이 on 2021/09/27.
//

import Foundation

class Logger {
    private enum Level: String {
        case e = "🚫"   //Error
        case w = "⚠️"   //Warning
        case i = "ℹ️"   //Info
        case d = "💬"   //Debug
        case v = "🔬"   //Verbose
        case wtf = "💢" //Angry developer
    }
    
    private static let dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    fileprivate static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    class func print(_ object: Any) {
        #if DEBUG
        Swift.print(object)
        #endif
    }
    
    private class func sourceFileName(_ filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    private class func __print(_ object: Any,
                               level: Level = Level.v,
                               filename: String = #file,
                               line: Int = #line,
                               column: Int = #column,
                               funcname: String = #function){
        
        #if DEBUG
        Swift.print("\(Date().toString()) \(level.rawValue) [\(sourceFileName(filename))]:\(line) \(column) \(funcname) -> \(object)")
        #endif
    }
    
    public class func e(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .e, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    public class func w(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .w, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    public class func i(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .i, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    public class func d(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .d, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    public class func v(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .v, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    public class func wtf(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .wtf, filename: filename, line: line, column: column, funcname: funcname)
    }
}

// MARK: Date extension for Logger
fileprivate extension Date {
    
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
