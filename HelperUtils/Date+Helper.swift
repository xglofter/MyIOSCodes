//
//  DateHelper.swift
//  TestSwift
//
//  Created by Richard on 2017/3/21.
//  Copyright © 2017年 Richard. All rights reserved.
//

import Foundation

public extension Date {
    
    /// DayID with Int type 如：20160101
    typealias DayIntID = Int
    /// DayID with String type 如："20160101"
    typealias DayStringID = String

    
    init?(from dayIntId: DayIntID) {
        let input = String(format: "%d", dayIntId)
        self.init(from: input)
    }
    
    init?(from dayStringId: DayStringID) {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormat.dateFormat = "yyyyMMdd"
        if let date = dateFormat.date(from: dayStringId) {
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        } else {
            return nil
        }
    }
    
    /// 返回某日期的DayIntID
    ///
    /// - @parameters theDate: 某日期
    /// - @returns: DayIntID: 如：20160101
    func toDayIntID() -> DayIntID {
        let calendar = Calendar.current
        let com = (calendar as NSCalendar).components([.year,.month,.day], from:self)
        let todayId = com.year! * 10000 + com.month! * 100 + com.day!
        return todayId
    }
    
    
    /// 返回某日期的DayStringID
    ///
    /// - Parameter theDate: 某日期
    /// - Returns: DayStringID: 如："20160101"
    func toDayStringID() -> DayStringID {
        return String(format: "%d", self.toDayIntID())
    }
    
    /// 返回某日期加上或减去一个时间后的日期
    ///
    /// - @parameters day: 日期的增量，为负数表示多少天前，反之多少天后
    /// - @parameters xxx: xxx的增量
    /// - @parameters byDate: 基准日期
    /// - @returns: Date?: 所得到的日期
    func dateByAddingTime(second: Int = 0, minute: Int = 0, hour: Int = 0, day: Int = 0, month: Int = 0, year: Int = 0) -> Date? {
        let currCalender = Calendar.current
        var com = DateComponents()
        com.year = year
        com.month = month
        com.day = day
        com.hour = hour
        com.minute = minute
        com.second = second
        return (currCalender as NSCalendar).date(byAdding: com, to: self, options: NSCalendar.Options.matchStrictly)
    }
    
    /// 比较两个日期是否为同一天
    ///
    /// - Parameter with: Date 被比较的日期
    /// - Returns: Bool 是否是同一天
    func isSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    /// 比较两个日期是否为同一月
    ///
    /// - Parameter with: Date 被比较的日期
    /// - Returns: Bool 是否是同一月
    func isSameMonth(as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    
    /// 比较两个日期是否为同一年
    ///
    /// - Parameter with: Date 被比较的日期
    /// - Returns: Bool 是否是同一年
    func isSameYear(as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    
}
