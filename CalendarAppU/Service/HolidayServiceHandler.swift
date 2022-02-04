//
//  HolidayServiceHandler.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/31/22.
//

import Foundation

/**
 A HolidayWebService Class that submits a url request the task is NOT stored and cannot be cancelled later
 a singleton
 */
class HolidayServiceHandler: HolidayWebService {
    
    static let shared = HolidayServiceHandler()

    private init(){}
       
    func cancel() {
        print(#function, "NA")
    }
    
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ()) {
        guard let url = holidayServiceURL(year: year, month: month, day: day) else { return completion(.failure(.malformedURL)) }

        // Early exit for testing

        //if day < 4 || day > 22 { /* proceed */ } else { return completion(.failure(.notImplemented)) }
        if day < 1 { /* proceed */ } else { return completion(.failure(.notImplemented)) }
        //if day < 2 { /* proceed */ } else { return completion(.failure(.notImplemented)) }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { return completion(.failure(.error(error))) }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.badresponse))
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("error statuscode", httpResponse.statusCode)
                return completion(.failure(.statusCode))
            }
            
            guard let jsonData = data else {
                return completion(.failure(.badresponseData))
            }
            
            guard let results = try? JSONDecoder().decode(Holidays.self, from: jsonData) else {
                return completion(.failure(.parse))
            }
            
            completion(.success(results))
            
        }.resume()
    }
}
