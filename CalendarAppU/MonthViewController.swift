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
        for weeks in monthStackView.arrangedSubviews {
            if let weeksStackView = weeks as? UIStackView {
                for dayOfWeekView in weeksStackView.arrangedSubviews {
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
        var day = 0
        
        if let week = monthStackView.arrangedSubviews[0] as? UIStackView {
            (1...7).forEach {
                if $0 == viewModel.startDay {
                    day = day + 1
                }
                week.addArrangedSubview(newDayView(for: day))
                if day > 0 {
                    day = day + 1
                }
            }
        }
        
        if let week = monthStackView.arrangedSubviews[1] as? UIStackView {
            (1...7).forEach { _ in
                week.addArrangedSubview(newDayView(for: day))
                day = day + 1
            }
        }

        if let week = monthStackView.arrangedSubviews[2] as? UIStackView {
            (1...7).forEach { _ in
                week.addArrangedSubview(newDayView(for: day))
                day = day + 1
            }
        }

        if let week = monthStackView.arrangedSubviews[3] as? UIStackView {
            (1...7).forEach { _ in
                week.addArrangedSubview(newDayView(for: day))
                day = day + 1
            }
        }
        
        if let week = monthStackView.arrangedSubviews[4] as? UIStackView {
            (1...7).forEach { _ in
                if day > viewModel.numberOfDaysInMonth {
                    week.addArrangedSubview(newDayView(for: 0))
                } else {
                    week.addArrangedSubview(newDayView(for: day))
                }
                day = day + 1
            }
        }
    }
}

    

    
