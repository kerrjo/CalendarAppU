//
//  MonthViewController.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/26/22.
//

import UIKit

class MonthViewController: UIViewController {

    var viewModel = MonthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onNewMonth = { [weak self] in
            self?.newMonth()
        }
        
        viewModel.onHolidays = { [weak self] holidays in
            self?.holidaysUpdated(holidays)
        }
    }

    @IBOutlet var monthStackView: UIStackView!
    
    private func newMonth() {
        removePopupViews()
        clearDayViews()
        addDayViews()
    }
    
    private func holidaysUpdated(_ holidays: [HolidayElement]) {
        print(#function)
        for holiday in holidays {
            DispatchQueue.main.async { [weak self] in
                self?.holidayDayView(day: Int(holiday.dateDay) ?? 0, name: holiday.name)
            }
        }
    }
    
    private func clearDayViews() {
        for week in monthStackView.arrangedSubviews {
            if let weekView = (week as? UIStackView) {
                for view in weekView.arrangedSubviews {
                    weekView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    private func holidayDayView(day: Int, name: String) {
        for week in monthStackView.arrangedSubviews {
            if let week = week as? UIStackView {
                
                for dayOfWeekView in week.arrangedSubviews {
                    if let dayView = dayOfWeekView as? DayView {
                        if dayView.day == day {
                            dayView.holidayText = name
                        }
                    }
                }
            }
        }
    }
}

extension MonthViewController: DaySelection {
    
    func onDaySelected(_ day: Int, text: String = "") {
        removePopupViews()
        addPopupView(for: day, text: text)
        updateDayViews()
    }
}

/// Manage popup

extension MonthViewController {
    
    private func removePopupViews() {
        for rowView in monthStackView.arrangedSubviews {
            if let popUp = rowView as? DayViewPopup {
                monthStackView.removeArrangedSubview(popUp)
                popUp.removeFromSuperview()
            }
        }
    }
    
    private func addPopupView(for day: Int, text: String = "") {
        if let week = findDayViewWeek(day: day) {
            let popView = DayViewPopup(day: day)
            popView.holidayText = text
            monthStackView.insertArrangedSubview(popView, at: week + 1)
        }
    }

    private func findDayViewWeek(day: Int) -> Int? {
        for (index, week) in monthStackView.arrangedSubviews.enumerated() {
            if let week = week as? UIStackView {
                for dayOfWeekView in week.arrangedSubviews {
                    if let dayView = dayOfWeekView as? DayView {
                        if dayView.day == day {
                            return index
                        }
                    }
                }
            }
        }
        return nil
    }
    
    private func updateDayViews() {
        for week in monthStackView.arrangedSubviews {
            if let week = week as? UIStackView {
                for dayOfWeekView in week.arrangedSubviews {
                    if let dayView = dayOfWeekView as? DayView {
                        dayView.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    private func hasPopupView() -> Bool {
        for rowView in monthStackView.arrangedSubviews {
            if let _ = rowView as? DayViewPopup {
                return true
            }
        }
        return false
    }
}


private extension MonthViewController {
    
    func newDayView(for day: Int) -> UIView {
        let dayView = DayView(day: day)
        dayView.daySelectionHandler = self
        return dayView
    }
    
    func addDayViews() {
        let week1 = monthStackView.arrangedSubviews[0] as! UIStackView
        let week2 = monthStackView.arrangedSubviews[1] as! UIStackView
        let week3 = monthStackView.arrangedSubviews[2] as! UIStackView
        let week4 = monthStackView.arrangedSubviews[3] as! UIStackView
        let week5 = monthStackView.arrangedSubviews[4] as! UIStackView
        let week6 = monthStackView.arrangedSubviews[5] as! UIStackView

        var day = 0
        let maxDays = viewModel.numberOfDaysInMonth

        (1...7).forEach {
            
            day = $0 == viewModel.startDay ? (day + 1) : (day + 0)
            /// skipping iteration until startday reched
            ///
            week1.addArrangedSubview(newDayView(for: day))
            /// increment only if greater than 0
            day = (day > 0) ? (day + 1) : (day + 0)
        }
        
        (1...7).forEach { _ in
            week2.addArrangedSubview(newDayView(for: day))
            day = day + 1
        }
        
        (1...7).forEach { _ in
            week3.addArrangedSubview(newDayView(for: day))
            day = day + 1
        }
        
        (1...7).forEach { _ in
            week4.addArrangedSubview(newDayView(for: day))
            day = day + 1
        }

        (1...7).forEach { _ in
            // use day counter until maxdays then use 0
            let dayValue = day > maxDays ? 0 : day
            
            week5.addArrangedSubview(newDayView(for: dayValue))
            day = day + 1
        }

        (1...7).forEach { _ in
            // use day counter until maxdays then use 0
            let dayValue = day > maxDays ? 0 : day
            
            week6.addArrangedSubview(newDayView(for: dayValue))
            day = day + 1
        }
    }
}
