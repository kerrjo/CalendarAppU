//
//  MonthViewModel.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/26/22.
//

import Foundation

protocol MonthViewing: AnyObject {
    var current: Int { get }
    var year: Int { get }
    func next()
    func previous()
    func startMonth()
    var startDay: Int { get } // day of week start month 0
    var onNewMonth: () -> () { get set }
    var numberOfDaysInMonth: Int { get }
    var onHolidays: ([HolidayElement])  -> () { get set }
    var monthName: String { get }
    var yearMonthTitle: String { get }
}

class MonthViewModel: MonthViewing {
    
    lazy var dateFormatter = DateFormatter()
    
    private var service: HolidayWebService?
    private var monthCalculator: MonthCalculating
    
    init(with calc: MonthCalculating? = nil, service: HolidayWebService? = nil) {
        if let calc = calc {
            monthCalculator = calc
        } else {
            monthCalculator = MonthCalculation()
        }
        
        if let service = service {
            self.service = service
        } else {
            self.service = HolidayServiceHandler.shared
        }
    }
    
    var numberOfDaysInMonth: Int {
        monthCalculator.numberOfDaysInMonth
    }

    var monthName: String {
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: monthCalculator.date)
    }
    
    var yearMonthTitle: String { "\(year)  " + monthName }
    
    // call when month changed
    var onNewMonth: () -> () = { }
    
    var onHolidays: ([HolidayElement])  -> () = { _ in }
    
    var startDay: Int { monthCalculator.startDayOfWeek }
    
    var current: Int { monthCalculator.mdyValues.0 }
    
    var year: Int { monthCalculator.mdyValues.2 }

    func startMonth() {
        newMonthCleanup()
        onNewMonth()
        serviceCalls()
    }

    func next() {
        monthCalculator.nextMonth()
        newMonthCleanup()
        onNewMonth()
        serviceCalls()
    }
    
    func previous() {
        monthCalculator.previousMonth()
        newMonthCleanup()
        onNewMonth()
        serviceCalls()
    }
    
    private var cancellableServiceCalls: [HolidayWebService] = []
    private var holidays: [HolidayElement] = []
}

// service calls

private extension MonthViewModel {

    func serviceCalls() {
        print(#function)
        serviceCallsNonCancelling()
        
        // serviceCallsCancelling()
    }

    func serviceCallsNonCancelling() {
        guard let service = service else { return }
        
        (1...numberOfDaysInMonth).forEach {
            service.fetchHolidays(year: year, month: current, day: $0) { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .success(let holidays):
                    if !holidays.isEmpty {
                        self.holidays = self.holidays + holidays
                        self.onHolidays(self.holidays)
                    }
                    print(holidays)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    func serviceCallsCancelling() {
        print(#function)

        (1...numberOfDaysInMonth).forEach {
            let service = HolidayService()
            
            service.fetchHolidays(year: year, month: current, day: $0) { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .success(let holidays):
                    if !holidays.isEmpty {
                        self.holidays = self.holidays + holidays
                        self.onHolidays(self.holidays)
                    }
                    print(holidays)
                case .failure(let error):
                    print(error)
                }
            }
            cancellableServiceCalls.append(service)
        }
    }
    
    func newMonthCleanup() {
        for service in cancellableServiceCalls {
            service.cancel()
        }
        cancellableServiceCalls = []
        holidays = []
    }
    
}
