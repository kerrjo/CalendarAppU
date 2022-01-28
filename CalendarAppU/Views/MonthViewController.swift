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
    
    func newMonth() {
        clearDayViews()
        addDayViews()
    }
    
    func holidaysUpdated(_ holidays: [HolidayElement]) {
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
    
    func holidayDayView(day: Int, name: String) {
        print(#function, day, name)
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


private extension MonthViewController {
    func newDayView(for day: Int) -> UIView {
        return DayView(day: day)
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
