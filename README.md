# QTimePicker
日期选择器

近日发现钉钉的日期选择器使用时比较方便，就试着写了一个，基本实现功能并适当做了些优化，先看效果：
<p align="center">
<img src="https://github.com/qyfeng009/QTimePicker/blob/master/QCalendarPicker.gif" width="266" height="500"/>
</p>

###### 思路
1、框架主要由三个部分组成：基础 QCalendarPicker, 日历模块 CalendarView, 时间选择模块 TimePickerView。
```
QCalendarPicker 负责作为基层负责显示界面、获取最终数据、底层基础操作等
CalendarView 单独的日历模块，输出选中的日期，是 QTimePicker 主要部分
TimePickerView 时间选择, 使用 UIDatePicker, 功能简单
```
2、主要说一说 CalendarView 的实现
```
使用 UICollectionView 作为日历单元格的布局，使之滚动分页 collectionView.isPagingEnabled = true。
采用 42 * 3 个item, 每一页42个item共三页。初始化时使 collectionView 滚到第二页即显示页面的第一个item的 下标是42.
每次滑动一页的时候会再次使 collectionView 滚到第二页，并重置数据
```
###### 使用
使用很简单，把 QTimePicker.swift 拖入项目，使用以下代码就行
```
let picker = QCalendarPicker { (date: String) in
 print(date)      
}
picker.show()
```
