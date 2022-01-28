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
        
        if day < 1 {
            // proceed
        } else {
            completion(.failure(.notImplemented))
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
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
        }
        
        dataTask?.resume()
        
    }
}


/// classic shared
public class HolidayServiceHandler: HolidayWebService {
    
    static let shared = HolidayServiceHandler()

    func cancel() {
        print(#function, "NA")
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
        
        if day == 1 { } else {
            return completion(.failure(.notImplemented)) }
        
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

