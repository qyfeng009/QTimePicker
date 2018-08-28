//
//  Extension_Date.swift
//  QTimePicker
//
//  Created by 009 on 2017/12/12.
//

import Foundation

extension Date {
    var year: Int {
        return components(date: self).year!
    }
    var month: Int {
        return components(date: self).month!
    }
    var day: Int {
        return components(date: self).day!
    }
    var hour: Int {
        return components(date: self).hour!
    }
    var minute: Int {
        return components(date: self).minute!
    }
    var second: Int {
        return components(date: self).second!
    }
    func components(date: Date) -> DateComponents {
        let calendar = Calendar.current
        let componentsSet = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        let components = calendar.dateComponents(componentsSet, from: date)
        return components
    }

    var daysInYear: Int {
        return (self.isLeapYear ? 366 : 365)
    }

    var isLeapYear: Bool {
        let year = self.year
        return (year%4==0 ? (year%100==0 ? (year%400==0 ? true : false) : true) : false)
    }

    /// 当前时间的月份的第一天是周几
    var firstWeekDayInThisMonth: Int {
        var calendar = Calendar.current
        let componentsSet = Set<Calendar.Component>([.year, .month, .day])
        var components = calendar.dateComponents(componentsSet, from: self)

        calendar.firstWeekday = 1
        components.day = 1
        let first = calendar.date(from: components)
        let firstWeekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: first!)
        return firstWeekDay! - 1
    }
    /// 当前时间的月份共有多少天
    var totalDaysInThisMonth: Int {
        let totalDays = Calendar.current.range(of: .day, in: .month, for: self)
        return (totalDays?.count)!
    }

    /// 上个月份的此刻日期时间
    var lastMonth: Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let newData = Calendar.current.date(byAdding: dateComponents, to: self)
        return newData!
    }
    /// 下个月份的此刻日期时间
    var nextMonth: Date {
        var dateComponents = DateComponents()
        dateComponents.month = +1
        let newData = Calendar.current.date(byAdding: dateComponents, to: self)
        return newData!
    }

    /// 格式化时间
    ///
    /// - Parameters:
    ///   - formatter: 格式 yyyy-MM-dd/YYYY-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss
    /// - Returns: 格式化后的时间 String
    func formatterDate(formatter: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatter
        let dateString = dateformatter.string(from: self)
        return dateString
    }


}
