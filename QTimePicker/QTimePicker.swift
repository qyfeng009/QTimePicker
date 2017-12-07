//
//  QTimePicker.swift
//  QTimePicker
//
//  Created by 009 on 2017/12/1.
//

import UIKit

private let screenWidth = UIScreen.main.bounds.width
private let screenHeight = UIScreen.main.bounds.height
private let keyWindow = UIApplication.shared.keyWindow
private let calendarItemWH: CGFloat = (screenWidth - 20 - 6 * 8) / 7
private var baseViewHeight = 49 + 30 + 6 * calendarItemWH + 6 * 8
typealias DidSelectedDate = (_ date: String) -> ()
class QTimePicker: UIView, UIGestureRecognizerDelegate, CalendarViewDelegate, TimePickerViewDelegate {
    
    var baseView: UIView!
    var dateBtn: UIButton!
    var timeBtn: UIButton!
    var currentDate: String!
    var currentTime: String!
    var cursorView: UIView!
    var calendarView: CalendarView!
    var timePickerView: TimePickerView!
    var selectedBack: DidSelectedDate?

    init(selectedDate: @escaping DidSelectedDate) {
        super.init(frame: UIScreen.main.bounds)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
        backgroundColor = .clear
        selectedBack = selectedDate
        
        if screenHeight == 812 {
            baseViewHeight = 49 + 30 + 6 * calendarItemWH + 6 * 8 + 34
        }
        
        baseView = UIView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: baseViewHeight))
        baseView.transform = CGAffineTransform.identity
        self.addSubview(baseView)
        baseView.backgroundColor = hexColor(hex: 0xF5F6F5)
        
        let date = Date()
        let year = CalendarData.year(date: date)
        let month = CalendarData.month(date: date)
        let day = CalendarData.day(date: date)
        currentDate = CalendarData.getYMD(date: date)
        currentTime = CalendarData.getHM(date: date)
        
        dateBtn = UIButton(frame: CGRect(x: 10, y: 0, width: 137, height: 49))
        dateBtn.setTitle("\(year)年\(month)月\(day)日", for: UIControlState.normal)
        dateBtn.setTitleColor(.darkGray, for: UIControlState.selected)
        dateBtn.setTitleColor(.gray, for: UIControlState.normal)
        dateBtn.isSelected = true
        dateBtn.addTarget(self, action: #selector(clickTimeBtn(_:)), for: UIControlEvents.touchUpInside)
        baseView.addSubview(dateBtn)
        
        timeBtn = UIButton(frame: CGRect(x: dateBtn.x + dateBtn.width + 10, y: dateBtn.y, width: 54, height: dateBtn.height))
        timeBtn.setTitle(currentTime, for: UIControlState.normal)
        timeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        timeBtn.setTitleColor(.darkGray, for: UIControlState.selected)
        timeBtn.setTitleColor(.gray, for: UIControlState.normal)
        timeBtn.isSelected = false
        timeBtn.addTarget(self, action: #selector(clickTimeBtn(_:)), for: UIControlEvents.touchUpInside)
        baseView.addSubview(timeBtn)
        
        let okBtn = UIButton(type: UIButtonType.system)
        okBtn.frame = CGRect(x: screenWidth - 10 - 64, y: dateBtn.y, width: 64, height: dateBtn.height)
        okBtn.setTitle("确定", for: UIControlState.normal)
        okBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        okBtn.addTarget(self, action: #selector(clickOKBtn), for: UIControlEvents.touchUpInside)
        baseView.addSubview(okBtn)
        
        cursorView = UIView(frame: CGRect(x: dateBtn.x, y: dateBtn.height - 2, width: dateBtn.width, height: 2))
        cursorView.backgroundColor = hexColor(hex: 0x7D7F82)
        baseView.addSubview(cursorView)
        baseView.sendSubview(toBack: cursorView)
        
        var calendarViewH = baseView.height - dateBtn.height
        if screenHeight == 812 {
            calendarViewH = baseView.height - dateBtn.height - 34
        }
        calendarView = CalendarView(frame: CGRect(x: 0, y: dateBtn.height, width: screenWidth, height: calendarViewH))
        calendarView.delegate = self
        baseView.addSubview(calendarView)
        timePickerView = TimePickerView(frame: calendarView.frame)
        timePickerView.x = baseView.width
        timePickerView.delegate = self
        baseView.addSubview(timePickerView)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CalendarViewDelegate
    @objc func clickTimeBtn(_ button: UIButton) {
        if !button.isSelected {
            button.isSelected = true
            if button == dateBtn {
                timeBtn.isSelected = false
                let rect = CGRect(x: dateBtn.x, y: dateBtn.height - 2, width: dateBtn.width, height: 2)
                UIView.animate(withDuration: 0.33) {
                    self.cursorView.frame = rect
                    self.calendarView.x = 0
                    self.timePickerView.x = self.baseView.width
                }
            } else {
                dateBtn.isSelected = false
                let rect = CGRect(x: timeBtn.x, y: timeBtn.height - 2, width: timeBtn.width, height: 2)
                UIView.animate(withDuration: 0.33) {
                    self.cursorView.frame = rect
                    self.calendarView.x = -self.baseView.width
                    self.timePickerView.x = 0
                }
            }
        }
    }
    // MARK: - CalendarViewDelegate
    func didSelectedDate(selecteDate: Date) {
        let selectedYear = CalendarData.year(date: selecteDate)
        let selectedMonth = CalendarData.month(date: selecteDate)
        let selectedDay = CalendarData.day(date: selecteDate)
        currentDate = CalendarData.getYMD(date: selecteDate)
        dateBtn.setTitle("\(selectedYear)年\(selectedMonth)月\(selectedDay)日", for: UIControlState.normal)
        
        let rect = CGRect(x: timeBtn.x, y: timeBtn.height - 2, width: timeBtn.width, height: 2)
        dateBtn.isSelected = false
        UIView.animate(withDuration: 0.33) {
            self.cursorView.frame = rect
            self.calendarView.x = -self.baseView.width
            self.timePickerView.x = 0
        }
    }
    // MARK: - TimePickerViewDelegate
    func selectedTime(time: String) {
        timeBtn.setTitle(time, for: UIControlState.normal)
        currentTime = time
    }
    
    /// 显示
    open func show() {
        keyWindow?.addSubview(self)
        keyWindow?.bringSubview(toFront: self)
        UIView.animate(withDuration: 0.21, animations: {
            self.baseView.transform = CGAffineTransform(translationX: 0, y:  -baseViewHeight)
            self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        })
    }
    @objc private func clickOKBtn() {
        selectedBack!(currentDate + " " + currentTime)
        close()
    }
    @objc private func close() {
        UIView.animate(withDuration: 0.15, animations: {
            self.baseView.transform = CGAffineTransform.identity
            self.backgroundColor = .clear
        }) { (finish: Bool) in
            self.removeFromSuperview()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != self {
            return false
        }
        return true
    }
}

//****************************< 以下日历模块 >************************************
// MARK: - 日历模块
/// 日历
protocol CalendarViewDelegate:NSObjectProtocol {
    func didSelectedDate(selecteDate: Date)
}
class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    var collectionView: UICollectionView!
    var currentDate : Date! = Date()
    var yearLbl: UILabel!
    var selectedDay: Date! = Date()
    weak var delegate: CalendarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        creatWeekTitle()
        
        collectionView = UICollectionView(frame: CGRect(x: 10, y: 30, width: self.width - 20, height: self.height - 30), collectionViewLayout: CalendarLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
        yearLbl = UILabel(frame: collectionView.bounds)
        yearLbl.textColor = hexColor(hex: 0xE9EDF2)
        yearLbl.font = UIFont(name: "DB LCD Temp", size: 110)
        yearLbl.textAlignment = NSTextAlignment.center
        yearLbl.adjustsFontSizeToFitWidth = true
        yearLbl.text = "\(CalendarData.year(date: currentDate))"
        addSubview(yearLbl)
        sendSubview(toBack: yearLbl)
        
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.setContentOffset(CGPoint(x: 0, y: (self.height - 30)*1), animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatWeekTitle() {
        let titles = ["日", "一", "二", "三", "四", "五", "六"]
        for i in 0..<titles.count {
            let label = UILabel(frame: CGRect(x: 10 + (((screenWidth - 20 - 6 * 8) / 7) * CGFloat(i)) + 8 * CGFloat(i), y: 0, width: (screenWidth - 20 - 6 * 8) / 7, height: 30))
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            label.text = titles[i]
            addSubview(label)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42*3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCell
        
        let daysInThisMonth = CalendarData.totalDaysInThisMonth(date: currentDate)
        let firstWeekDay = CalendarData.firstWeekDayInThisMonth(date: currentDate)
        let currentMonth = CalendarData.month(date: currentDate)
        let currentYear = CalendarData.year(date: currentDate)
        let lastMonthDate = CalendarData.lastMonth(date: currentDate)
        let lastMonth = CalendarData.month(date: lastMonthDate)
        let daysInLastMonth = CalendarData.totalDaysInThisMonth(date: lastMonthDate)
        let nextMonthDate = CalendarData.nextMonth(date: currentDate)
        let nextMonth = CalendarData.month(date: nextMonthDate)
        let daysInNextMonth = CalendarData.totalDaysInThisMonth(date: nextMonthDate)
        
        let i = (indexPath.row - 42)
        
        if i < firstWeekDay {
            let lastDay = (daysInLastMonth - firstWeekDay + 1 + i)
            if lastDay == 1 {
                cell.text = "\(lastMonth)月"
            } else if lastDay <= 0 {
                let doubleLastMonthDate = CalendarData.lastMonth(date: lastMonthDate)
                let daysInDoubleLastMonth = CalendarData.totalDaysInThisMonth(date: doubleLastMonthDate)
                cell.text = "\(daysInDoubleLastMonth + lastDay)"
            } else {
                cell.text = String(lastDay)
            }
            cell.textColor = .lightGray
            cell.backgroundColor = UIColor.clear
            cell.isUserInteractionEnabled = false
        } else if i > firstWeekDay + daysInThisMonth - 1 {
            let nextCurrentDay = (i - firstWeekDay - daysInThisMonth + 1)
            if nextCurrentDay <= daysInNextMonth {
                if nextCurrentDay == 1 {
                    cell.text = String(nextMonth) + "月"
                } else {
                    cell.text = String(nextCurrentDay)
                }
            } else {
                let doubleNextMonthCurrentDay = (nextCurrentDay - daysInNextMonth)
                if doubleNextMonthCurrentDay == 1 {
                    if nextMonth == 12 {
                        cell.text = "1月"
                    } else {
                        cell.text = "\(nextMonth + 1)月"
                    }
                } else {
                    cell.text = "\(doubleNextMonthCurrentDay)"
                }
            }
            cell.textColor = .lightGray
            cell.backgroundColor = UIColor.clear
            cell.isUserInteractionEnabled = false
        } else {
            let currentDay = (i - firstWeekDay + 1)
            if currentDay == CalendarData.day(date: Date())
                && currentMonth == CalendarData.month(date: Date())
                && currentYear == CalendarData.year(date: Date()) {
                cell.text = String(currentDay)
                if currentDay == CalendarData.day(date: selectedDay)
                    && currentMonth == CalendarData.month(date: selectedDay)
                    && currentYear == CalendarData.year(date: selectedDay) {
                    cell.backgroundColor = hexColor(hex: 0x7D7F82)
                    cell.textColor = .white
                } else {
                    cell.backgroundColor = hexColor(hex: 0xE9F3FE)
                    cell.textColor = hexColor(hex: 0x297DFF)
                }
            } else {
                if currentDay == 1 {
                    cell.text = String(currentMonth) + "月"
                    if currentDay == CalendarData.day(date: selectedDay)
                        && currentMonth == CalendarData.month(date: selectedDay)
                        && currentYear == CalendarData.year(date: selectedDay) {
                        cell.textColor = .white
                        cell.backgroundColor = hexColor(hex: 0x7D7F82)
                    } else {
                        cell.textColor = hexColor(hex: 0x297DFF)
                        cell.backgroundColor = UIColor.clear
                    }
                } else {
                    if currentDay == CalendarData.day(date: selectedDay)
                        && currentMonth == CalendarData.month(date: selectedDay)
                        && currentYear == CalendarData.year(date: selectedDay) {
                        cell.textColor = .white
                        cell.backgroundColor = hexColor(hex: 0x7D7F82)
                    } else {
                        cell.textColor = .black
                        cell.backgroundColor = UIColor.clear
                    }
                    cell.text = String(currentDay)
                }
            }
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    /// 上次选中的日期, 默认初始值为当前日期
    var lastSelected: NSInteger! = (42 + CalendarData.firstWeekDayInThisMonth(date: Date()) - 1 + CalendarData.day(date: Date()))
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 计算选中的日期
        let firstWeekDay = CalendarData.firstWeekDayInThisMonth(date: currentDate)
        let clickDay = (indexPath.row - 42 - firstWeekDay + 1)
        
        var dateComponents = DateComponents()
        dateComponents.day = -CalendarData.day(date: currentDate) + clickDay
        let clickDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        selectedDay = clickDate
        delegate?.didSelectedDate(selecteDate: clickDate!)
        
        // 刷新上次选中和当前选中的items
        var arr = Array<IndexPath>()
        if lastSelected != indexPath.row {
            arr.append(IndexPath(item: lastSelected, section: 0))
        }
        arr.append(IndexPath(item: indexPath.row, section: 0))
        collectionView.reloadItems(at: arr)
        
        lastSelected = indexPath.row // 记录选中的item
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let direction = lroundf(Float(collectionView.contentOffset.y / collectionView.height))
        
        if direction == 0 {
            self.currentDate = CalendarData.lastMonth(date: self.currentDate)
            reseData()
        }
        if direction == 2 {
            self.currentDate = CalendarData.nextMonth(date: self.currentDate)
            reseData()
        }
    }
    func reseData() {
        collectionView.setContentOffset(CGPoint(x: 0, y: (self.height - 30)*1), animated: false)
        collectionView.reloadData()
        self.yearLbl.text = "\(CalendarData.year(date: self.currentDate))"
    }
    
}
// MARK: - CalendarLayout
/// 定义 UICollectionViewFlowLayout
class CalendarLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        itemSize = CGSize(width: calendarItemWH, height: calendarItemWH)
        scrollDirection = .vertical
        minimumLineSpacing = 8
        minimumInteritemSpacing = 8
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - 日历单元 cell
/// 日历单元 cell
class CalendarCell: UICollectionViewCell {
    open var text: String! {
        set {
            self.textLbl.text = newValue
        }
        get {
            return self.text
        }
    }
    open var textColor: UIColor! {
        set {
            self.textLbl.textColor = newValue
        }
        get {
            return self.textColor
        }
    }
    private lazy var textLbl: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        if #available(iOS 10.0, *) {
            label.adjustsFontForContentSizeCategory = true
        }
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(textLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - 日历数据
/// 日历数据
class CalendarData: NSObject {
    class func second(date: Date) -> NSInteger {
        return components(date: date).second!
    }
    class func minute(date: Date) -> NSInteger {
        return components(date: date).minute!
    }
    class func hour(date: Date) -> NSInteger {
        return components(date: date).hour!
    }
    class func day(date: Date) -> NSInteger {
        return components(date: date).day!
    }
    class func month(date: Date) -> NSInteger {
        return components(date: date).month!
    }
    class func year(date: Date) -> NSInteger {
        return components(date: date).year!
    }
    class func firstWeekDayInThisMonth(date: Date) -> NSInteger {
        var calendar = Calendar.current
        let componentsSet = Set<Calendar.Component>([.year, .month, .day])
        var components = calendar.dateComponents(componentsSet, from: date)
        
        calendar.firstWeekday = 1
        components.day = 1
        let first = calendar.date(from: components)
        let firstWeekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: first!)
        return firstWeekDay! - 1
    }
    class func totalDaysInThisMonth(date: Date) -> NSInteger {
        let totalDays = Calendar.current.range(of: .day, in: .month, for: date)
        return (totalDays?.count)!
    }
    class func lastMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let newData = Calendar.current.date(byAdding: dateComponents, to: date)
        return newData!
    }
    class func nextMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = +1
        let newData = Calendar.current.date(byAdding: dateComponents, to: date)
        return newData!
    }
    
    class func components(date: Date) -> DateComponents {
        let calendar = Calendar.current
        let componentsSet = Set<Calendar.Component>([.year, .month, .day, .hour, .minute])
        let components = calendar.dateComponents(componentsSet, from: date)
        return components
    }
    class func getYMD(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let ymd = dateformatter.string(from: date)
        return ymd
    }
    class func getHM(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        let hm = dateformatter.string(from: date)
        return hm
    }
}

//***************************< 以下时间选择模块 >**********************************
// MARK: -  时间选择模块
protocol TimePickerViewDelegate:NSObjectProtocol {
    func selectedTime(time: String)
}
class TimePickerView: UIView {

    var datePicker: UIDatePicker!
    weak var delegate: TimePickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        datePicker = UIDatePicker(frame: frame)
        datePicker.centerY = self.height / 2
        datePicker.locale = Locale(identifier: "zh")
        datePicker.datePickerMode = UIDatePickerMode.time
        datePicker.addTarget(self, action: #selector(datePickerValueChange(_:)), for: UIControlEvents.valueChanged)
        addSubview(datePicker)
    }
    @objc func datePickerValueChange(_ datePicker: UIDatePicker) {
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: date)
        delegate?.selectedTime(time: time)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//******************************************************************************
// MARK: - 16进制色值转RGB色值
/// 16进制色值转RGB色值
///
/// - Parameter hex: 16进制色值，样式为 0x000000
/// - Returns: 返回 UIColor
private func hexColor(hex: Int) -> UIColor {
    return UIColor(red: CGFloat((Double((hex & 0xFF0000) >> 16)) / 255.0), green: CGFloat((Double((hex & 0xFF00) >> 8)) / 255.0), blue: CGFloat((Double((hex & 0xFF))) / 255.0), alpha: 1.0)
}

// MARK: - UIView 的坐标扩展
private extension UIView {
    var x: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    var y: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    var centerX: CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }
    var centerY: CGFloat {
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get {
            return self.center.y
        }
    }
    var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
}
