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
    var dataTask: URLSessionDataTask? { get }
    func cancel()
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ())
}

public class HolidayService: HolidayWebService {

    private(set) var dataTask: URLSessionDataTask?

    func cancel() {
        guard let dataTask = dataTask else { return }
        dataTask.cancel()
    }
    
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ()) {
        
        guard var components = URLComponents(string: "https://holidays.abstractapi.com/v1/") else { return }
        
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "f27cda4192bc4425b8da32db7d3f925d"),
            URLQueryItem(name: "country", value: "US"),
            URLQueryItem(name: "year", value: "\(year)"),
            URLQueryItem(name: "month", value: "\(month)"),
            URLQueryItem(name: "day", value: "\(day)"),
            ]
        
        print(components.url as Any)
        
        guard let url = components.url else { return completion(.failure(.malformedURL)) }
        
        if day == 1 {

        } else {
            completion(.failure(.notImplemented))
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(.error(error)))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.badresponse))
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("error statuscode", httpResponse.statusCode)
                completion(.failure(.statusCode))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(.badresponseData))
                return
            }
            
            guard let results = try? JSONDecoder().decode(Holidays.self, from: jsonData) else {
                completion(.failure(.parse))
                return
            }
            
            completion(.success(results))
        }
        
        dataTask?.resume()
        
    }
}
