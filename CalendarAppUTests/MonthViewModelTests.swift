//
//  MonthViewModelTests.swift
//  CalendarAppUTests
//
//  Created by JOSEPH KERR on 1/26/22.
//

import XCTest
@testable import CalendarAppU

class MonthViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValues() throws {
        let sut = MonthCalculation(m: 1, d: 26, y: 2022) as MonthCalculating
        let values = sut.mdyValues
        XCTAssertEqual(1, values.0)
        XCTAssertEqual(26, values.1)
        XCTAssertEqual(2022, values.2)
    }
    
    func testNumberOfDaysInMonth() throws {
        let sut = MonthCalculation(m: 9, d: 26, y: 2022)
        
        let value = sut.numberOfDaysInMonth
        XCTAssertEqual(30, value)
    }

    func testStartDayOfWeek() throws {
        let sut = MonthCalculation(m: 1, d: 26, y: 2022)
        let value = sut.startDayOfWeek
        XCTAssertEqual(7, value)
    }

    func testStartDayOfWeekOne() throws {
        let sut = MonthCalculation(m: 8, d: 26, y: 2021)
        let value = sut.startDayOfWeek
        XCTAssertEqual(1, value)
    }

    func testPreviousMonth() throws {
        let sut = MonthCalculation(m: 4, d: 26, y: 2022)
        //sut.incrementMonth(by: -1)
        sut.previousMonth()
        let values = sut.mdyValues
        XCTAssertEqual(3, values.0)
    }
    
    func testNextMonth() throws {
        let sut = MonthCalculation(m: 4, d: 26, y: 2022)
        //sut.incrementMonth(by: 1)
        sut.nextMonth()
        let values = sut.mdyValues
        XCTAssertEqual(5, values.0)
    }

    func testNextMonthCrossoverYear() throws {
        let sut = MonthCalculation(m: 12, d: 26, y: 2022)
        //sut.incrementMonth(by: 1)
        sut.nextMonth()
        let values = sut.mdyValues
        XCTAssertEqual(1, values.0)
        XCTAssertEqual(2023, values.2)
    }

    func testPreviousMonthCrossoverYear() throws {
        let sut = MonthCalculation(m: 1, d: 26, y: 2022)
        //sut.incrementMonth(by: -1)
        sut.previousMonth()
        let values = sut.mdyValues
        XCTAssertEqual(12, values.0)
        XCTAssertEqual(2021, values.2)
    }

}
