//
//  MonthViewController.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/26/22.
//

import UIKit

/**
 A view controller presenting days in rows and columns
 A nonpaging function will update the same grid when navigating
 `viewModel` is init at init of this contoller
 
 A  paging impl will create a new instance of one of these
 `viewModel` is set using  installedViewModel

 */
class MonthViewController: UIViewController {

    var viewModel: MonthViewing! = MonthViewModel()
    
    var pagingEnabled = false
    var installedViewModel: MonthViewing? {
        didSet {
            viewModel = installedViewModel ?? MonthViewModel()
            addListeners()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !pagingEnabled {
            addListeners()
        }
    }
    
    @IBOutlet var monthStackView: UIStackView!

    private func addListeners() {
        viewModel.onNewMonth = { [weak self] in
            self?.newMonth()
        }
        
        viewModel.onHolidays = { [weak self] holidays in
            self?.holidaysUpdated(holidays)
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

extension MonthViewController  {
    private func newMonth() {
        removePopupViews()
        clearDayViews()
        addDayViews()
    }

    private func clearDayViews() {
        for week in monthStackView.arrangedSubviews {
            guard let week = week as? UIStackView else { continue }
            
            for view in week.arrangedSubviews {
                week.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
    }

    private func holidaysUpdated(_ holidays: [HolidayElement]) {
        for holiday in holidays {
            DispatchQueue.main.async { [weak self] in
                self?.updateHolidayDayView(day: Int(holiday.dateDay) ?? 0, name: holiday.name)
            }
        }
    }
    
    private func updateHolidayDayView(day: Int, name: String) {
        for week in monthStackView.arrangedSubviews {
            guard let week = week as? UIStackView else { continue }
            
            for dayOfWeekView in week.arrangedSubviews {
                guard let dayView = dayOfWeekView as? DayView else { continue }
                if dayView.day == day {
                    dayView.holidayText = name
                }
            }
        }
    }
}


/// Manage popup

extension MonthViewController {
    
    private func removePopupViews() {
        for rowView in monthStackView.arrangedSubviews {
            guard let popUp = rowView as? DayViewPopup else { continue }
            monthStackView.removeArrangedSubview(popUp)
            popUp.removeFromSuperview()
        }
    }
    
    private func addPopupView(for day: Int, text: String = "") {
        guard let weekIndex = findDayViewWeek(day: day) else { return }
        
        let popView = DayViewPopup(day: day)
        popView.holidayText = text
        monthStackView.insertArrangedSubview(popView, at: weekIndex + 1)
    }

    private func findDayViewWeek(day: Int) -> Int? {
        for (index, week) in monthStackView.arrangedSubviews.enumerated() {
            guard let week = week as? UIStackView else { continue }
            
            for dayOfWeekView in week.arrangedSubviews {
                guard let dayView = dayOfWeekView as? DayView else { continue }
                if dayView.day == day {
                    return index
                }
            }
        }
        return nil
    }
    
    private func updateDayViews() {
        for week in monthStackView.arrangedSubviews {
            guard let week = week as? UIStackView else { continue }
            
            for dayOfWeekView in week.arrangedSubviews {
                if let dayView = dayOfWeekView as? DayView {
                    dayView.layoutIfNeeded()
                }
            }
        }
    }
    
    private func hasPopupView() -> Bool {
        for rowView in monthStackView.arrangedSubviews {
            guard let _ = rowView as? DayViewPopup else { continue }
            return true
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
