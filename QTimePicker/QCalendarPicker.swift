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

class QCalendarPicker: UIView, UIGestureRecognizerDelegate, CalendarViewDelegate, TimePickerViewDelegate {
    typealias DidSelectedDate = (_ date: String) -> Void
    
    private var baseView: UIView!
    private var dateBtn: UIButton!
    private var timeBtn: UIButton!
    private var currentDate: String!
    private var currentTime: String!
    private var cursorView: UIView!
    private var selectedBack: DidSelectedDate?
    
    private lazy var calendarView: CalendarView! = {
        var calendarViewH = baseView.height - dateBtn.height
        if UIDevice.isXSeries() == true {
            calendarViewH = baseView.height - dateBtn.height - 34
        }
        let calendarView = CalendarView(frame: CGRect(x: 0, y: dateBtn.height, width: screenWidth, height: calendarViewH))
        calendarView.delegate = self
        return calendarView
    }()
    private lazy var timePickerView: TimePickerView! = {
        let timePickerView = TimePickerView(frame: calendarView.frame)
        timePickerView.x = baseView.width
        timePickerView.delegate = self
        return timePickerView
    }()
    open var isAllowSelectTime: Bool? = true {
        didSet {
            if isAllowSelectTime == true {
                timeBtn.isHidden = false
            } else {
                timeBtn.isHidden = true
            }
        }
    }
    
    init(selectedDate: @escaping DidSelectedDate) {
        super.init(frame: UIScreen.main.bounds)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
        backgroundColor = .clear
        selectedBack = selectedDate
        if UIDevice.isXSeries() == true {
            baseViewHeight = 49 + 30 + 6 * calendarItemWH + 6 * 8 + 34
        }
        
        baseView = UIView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: baseViewHeight))
        baseView.transform = CGAffineTransform.identity
        self.addSubview(baseView)
        baseView.backgroundColor = UIColor.hex(hex: 0xF5F6F5)
        
        let date = Date()
        let year = date.year
        let month = date.month
        let day = date.day
        currentDate = date.formatterDate(formatter: "YYYY-MM-dd")
        currentTime = date.formatterDate(formatter: "HH:mm")
        
        dateBtn = UIButton(frame: CGRect(x: 10, y: 0, width: 137, height: 49))
        dateBtn.setTitle("\(year)年\(month)月\(day)日", for: UIControl.State.normal)
        dateBtn.setTitleColor(.darkGray, for: UIControl.State.selected)
        dateBtn.setTitleColor(.gray, for: UIControl.State.normal)
        dateBtn.isSelected = true
        dateBtn.addTarget(self, action: #selector(clickTimeBtn(_:)), for: UIControl.Event.touchUpInside)
        baseView.addSubview(dateBtn)
        
        timeBtn = UIButton(frame: CGRect(x: dateBtn.x + dateBtn.width + 10, y: dateBtn.y, width: 54, height: dateBtn.height))
        timeBtn.setTitle(currentTime, for: UIControl.State.normal)
        timeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        timeBtn.setTitleColor(.darkGray, for: UIControl.State.selected)
        timeBtn.setTitleColor(.gray, for: UIControl.State.normal)
        timeBtn.isSelected = false
        timeBtn.addTarget(self, action: #selector(clickTimeBtn(_:)), for: UIControl.Event.touchUpInside)
        baseView.addSubview(timeBtn)
        
        let okBtn = UIButton(type: UIButton.ButtonType.system)
        okBtn.frame = CGRect(x: screenWidth - 10 - 64, y: dateBtn.y, width: 64, height: dateBtn.height)
        okBtn.setTitle("确定", for: UIControl.State.normal)
        okBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        okBtn.addTarget(self, action: #selector(clickOKBtn), for: UIControl.Event.touchUpInside)
        baseView.addSubview(okBtn)
        
        cursorView = UIView(frame: CGRect(x: dateBtn.x, y: dateBtn.height - 2, width: dateBtn.width, height: 2))
        cursorView.backgroundColor = UIColor.hex(hex: 0x7D7F82)
        baseView.addSubview(cursorView)
        baseView.sendSubviewToBack(cursorView)
        
        
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
                if !baseView.subviews.contains(timePickerView) {
                    self.baseView.addSubview(self.timePickerView)
                }
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
        let selectedYear = selecteDate.year
        let selectedMonth = selecteDate.month
        let selectedDay = selecteDate.day
        currentDate = selecteDate.formatterDate(formatter: "YYYY-MM-dd")
        dateBtn.setTitle("\(selectedYear)年\(selectedMonth)月\(selectedDay)日", for: UIControl.State.normal)
        
        if isAllowSelectTime == true {
            if !baseView.subviews.contains(timePickerView) {
                self.baseView.addSubview(self.timePickerView)
            }
            let rect = CGRect(x: timeBtn.x, y: timeBtn.height - 2, width: timeBtn.width, height: 2)
            dateBtn.isSelected = false
            UIView.animate(withDuration: 0.33) {
                self.cursorView.frame = rect
                self.calendarView.x = -self.baseView.width
                self.timePickerView.x = 0
            }
        }
    }
    // MARK: - TimePickerViewDelegate
    func selectedTime(time: String) {
        timeBtn.setTitle(time, for: UIControl.State.normal)
        currentTime = time
    }
    
    /// 显示
    open func show() {
        keyWindow?.addSubview(self)
        keyWindow?.bringSubviewToFront(self)
        UIView.animate(withDuration: 0.21, animations: {
            self.baseView.transform = CGAffineTransform(translationX: 0, y:  -baseViewHeight)
            self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }, completion: { (finish: Bool) in
            self.baseView.addSubview(self.calendarView)
        } )
        
    }
    @objc private func clickOKBtn() {
        if isAllowSelectTime == true {
            selectedBack!(currentDate + " " + currentTime)
        } else {
            selectedBack!(currentDate)
        }
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
        yearLbl.textColor = UIColor.hex(hex: 0xE9EDF2)
        yearLbl.font = UIFont(name: "DB LCD Temp", size: 110)
        yearLbl.textAlignment = NSTextAlignment.center
        yearLbl.adjustsFontSizeToFitWidth = true
        yearLbl.text = "\(currentDate.year)"
        addSubview(yearLbl)
        sendSubviewToBack(yearLbl)
        
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
        
        let daysInThisMonth = currentDate.totalDaysInThisMonth
        let firstWeekDay = currentDate.firstWeekDayInThisMonth
        let currentMonth = currentDate.month
        let currentYear = currentDate.year
        let lastMonthDate = currentDate.lastMonth
        let lastMonth = lastMonthDate.month
        let daysInLastMonth = lastMonthDate.totalDaysInThisMonth
        let nextMonthDate = currentDate.nextMonth
        let nextMonth = nextMonthDate.month
        let daysInNextMonth = nextMonthDate.totalDaysInThisMonth
        
        let i = (indexPath.row - 42)
        
        if i < firstWeekDay {
            let lastDay = (daysInLastMonth - firstWeekDay + 1 + i)
            if lastDay == 1 {
                cell.text = "\(lastMonth)月"
            } else if lastDay <= 0 {
                let doubleLastMonthDate = lastMonthDate.lastMonth
                let daysInDoubleLastMonth = doubleLastMonthDate.totalDaysInThisMonth
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
            if currentDay == Date().day
                && currentMonth == Date().month
                && currentYear == Date().year {
                cell.text = String(currentDay)
                if currentDay == selectedDay.day
                    && currentMonth == selectedDay.month
                    && currentYear == selectedDay.year {
                    cell.backgroundColor = UIColor.hex(hex: 0x7D7F82)
                    cell.textColor = .white
                } else {
                    cell.backgroundColor = UIColor.hex(hex: 0xE9F3FE)
                    cell.textColor = UIColor.hex(hex: 0x297DFF)
                }
            } else {
                if currentDay == 1 {
                    cell.text = String(currentMonth) + "月"
                    if currentDay == selectedDay.day
                        && currentMonth == selectedDay.month
                        && currentYear == selectedDay.year {
                        cell.textColor = .white
                        cell.backgroundColor = UIColor.hex(hex: 0x7D7F82)
                    } else {
                        cell.textColor = UIColor.hex(hex: 0x297DFF)
                        cell.backgroundColor = UIColor.clear
                    }
                } else {
                    if currentDay == selectedDay.day
                        && currentMonth == selectedDay.month
                        && currentYear == selectedDay.year {
                        cell.textColor = .white
                        cell.backgroundColor = UIColor.hex(hex: 0x7D7F82)
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
    var lastSelected: NSInteger! = (42 + Date().firstWeekDayInThisMonth - 1 + Date().day)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 计算选中的日期
        let firstWeekDay = currentDate.firstWeekDayInThisMonth
        let clickDay = (indexPath.row - 42 - firstWeekDay + 1)
        
        var dateComponents = DateComponents()
        dateComponents.day = -currentDate.day + clickDay
        let clickDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        selectedDay = clickDate
        delegate?.didSelectedDate(selecteDate: clickDate!)
        
        // 刷新上次选中和当前选中的items
        var arr = [IndexPath]()
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
            self.currentDate = self.currentDate.lastMonth
            reseData()
        }
        if direction == 2 {
            self.currentDate = self.currentDate.nextMonth
            reseData()
        }
    }
    func reseData() {
        collectionView.setContentOffset(CGPoint(x: 0, y: (self.height - 30)*1), animated: false)
        collectionView.reloadData()
        self.yearLbl.text = "\(self.currentDate.year)"
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
            return self.textLbl.text
        }
    }
    open var textColor: UIColor! {
        set {
            self.textLbl.textColor = newValue
        }
        get {
            return self.textLbl.textColor
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

//***************************< 以下时间选择模块 >**********************************
// MARK: - 时间选择模块
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
        datePicker.datePickerMode = UIDatePicker.Mode.time
        datePicker.addTarget(self, action: #selector(datePickerValueChange(_:)), for: UIControl.Event.valueChanged)
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



