//
//  Extension_String.swift
//  QTimePicker
//
//  Created by 009 on 2017/12/13.
//

import Foundation

extension String {

    // MARK: 字符串截取

    /// 截取字符串从开始到 index
    ///
    /// - Parameter index: 截止字符下标
    /// - Returns: 截取的 String
    func substring(to index: Int) -> String {
        guard let end_Index = validEndIndex(original: index) else {
            return self
        }
        return String(self[startIndex..<end_Index])
    }
    /// 截取字符串从index到结束
    ///
    /// - Parameter index: 开始字符的下标
    /// - Returns: 截取的 String
    func substring(from index: Int) -> String {
        guard let start_index = validStartIndex(original: index)  else {
            return self
        }
        return String(self[start_index..<endIndex])
    }
    /// 切割字符串(区间范围 前闭后开)
    ///
    /// - Parameter range: 截取的区间范围
    /// - Returns: 截取的 String
    func sliceString(_ range: CountableRange<Int>) -> String {
        guard
            let startIndex = validStartIndex(original: range.lowerBound),
            let endIndex   = validEndIndex(original: range.upperBound),
            startIndex <= endIndex
            else {
                return ""
        }
        return String(self[startIndex..<endIndex])
    }
    /// 切割字符串(区间范围 前闭后闭)
    ///
    /// - Parameter range: 截取的区间范围
    /// - Returns: 截取的 String
    func sliceString(_ range: CountableClosedRange<Int>) -> String {
        guard
            let start_Index = validStartIndex(original: range.lowerBound),
            let end_Index   = validEndIndex(original: range.upperBound),
            startIndex <= endIndex
            else {
                return ""
        }
        
        if endIndex.utf16Offset(in: self) <= end_Index.utf16Offset(in: self) {
            return String(self[start_Index..<endIndex])
        }
        return String(self[start_Index...end_Index])
    }
    // MARK: - 校验字符串位置 是否合理，并返回String.Index
    private func validIndex(original: Int) -> String.Index {
        switch original {
        case ...startIndex.utf16Offset(in: self) : return startIndex
        case endIndex.utf16Offset(in: self)...   : return endIndex
        default                          : return index(startIndex, offsetBy: original)
        }
    }
    // MARK: - 校验是否是合法的起始位置
    private func validStartIndex(original: Int) -> String.Index? {
        guard original <= endIndex.utf16Offset(in: self) else { return nil }
        return validIndex(original: original)
    }
    // MARK: - 校验是否是合法的结束位置
    private func validEndIndex(original: Int) -> String.Index? {
        guard original >= startIndex.utf16Offset(in: self) else { return nil }
        return validIndex(original: original)
    }

    /// 字符串时间转 Date
    ///
    /// - Parameter formatter: 字符串时间的格式 yyyy-MM-dd/YYYY-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss
    /// - Returns: Date
    func toDate(formatter: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = formatter
        let date = dateFormatter.date(from: self)
        return date!
    }
    
}

extension Collection where Element: Equatable {
    func indexDistance(of element: Element) -> Int? {
        guard let index = firstIndex(of: element) else { return nil }
        return distance(from: startIndex, to: index)
    }
}
extension StringProtocol {
    func indexDistance(of string: Self) -> Int? {
        guard let index = range(of: string)?.lowerBound else { return nil }
        return distance(from: startIndex, to: index)
    }
}
