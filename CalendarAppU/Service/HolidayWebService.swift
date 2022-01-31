//
//  HolidayWebService.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/26/22.
//

import Foundation

enum FetchError: Error {
    case error(Error)
    case malformedURL
    case statusCode
    case parse
    case badresponseData
    case badresponse
    case notImplemented
}

protocol HolidayWebService {
    func cancel()
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ())
}
