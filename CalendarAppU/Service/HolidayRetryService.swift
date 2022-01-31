//
//  HolidayRetryService.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/30/22.
//

import Foundation
import Combine

/*
 dataTaskPublisher brought to you by donnywals
 
 https://www.donnywals.com/retrying-a-network-request-with-a-delay-in-combine/
 
 donnywals/RetryAfter.swift
 https://gist.github.com/donnywals/83985376d4f83842d505e2868c3498c3
 */

enum DataTaskError: Error {
    case rateLimit(UUID)
    case serverBusy(UUID)
    case invalidResponse
}

class HolidayFetcher {
  
    var cancellables = Set<AnyCancellable>()
    
    // Because I don't like typing long stuff
    typealias DataTaskOutput = URLSession.DataTaskPublisher.Output
    typealias DataTaskResult = Result<DataTaskOutput, Error>
    
    func fetch(url: URL, completion: @escaping (Result<Holidays, FetchError>) -> ()) {
        print(#function)

        URLSession.shared.dataTaskPublisher(for: url)
        // analyze the response to ensure we have a response that we want to try
        // I transform output -> Result so we can work around the tryCatch later if we encountered a non-retryable error
            .tryMap({ (dataTaskOutput: DataTaskOutput) -> DataTaskResult in
                // infamous "should never happen" situation
                guard let response = dataTaskOutput.response as? HTTPURLResponse else {
                    completion(.failure(.badresponse))
                    throw DataTaskError.invalidResponse
                }
                
                // we want to retry a rate limit error
                if response.statusCode == 429 {
                    throw DataTaskError.rateLimit(UUID())
                }
                
                // we don't want to retry anything else
                return .success(dataTaskOutput)
            })
        // catch any errors
            .catch({ (error: Error) -> AnyPublisher<DataTaskResult, Error> in
                switch error {
                case DataTaskError.rateLimit(let uuid):
                    print("caught error: \(uuid)")
                    // return a Fail publisher that fails after 3 seconds, this means the `retry` will fire after 3s
                    return Fail(error: error)
                        .delay(for: 2, scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
                default:
                    completion(.failure(.error(error)))
                    
                    // We encountered a non-retryable error, wrap in Result so the publisher succeeds and we'll extract the error later
                    return Just(.failure(error))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            })
            .retry(5)
            .tryMap({ result in
                // Result -> Result.Success or emit Result.Failure
                return try result.get()
            })
            .map { $0.data }
            .decode(type: Holidays.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                completion(.success(value))
            })
            .store(in: &cancellables)
    }
}

class HolidayRetryService: HolidayWebService {
    
    private(set) var fetcher: HolidayFetcher?
    
    func cancel() {
        if fetcher != nil {
            print(#function, "cancelled")
            fetcher = nil
        } else {
            print(#function, "no fetcher")
        }
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
        
        //print(components.url as Any)
        
        guard let url = components.url else { return completion(.failure(.malformedURL)) }
        
        //if day < 3 || day > 27 { /* proceed */ } else { return completion(.failure(.notImplemented)) }
        if day < 1 { /* proceed */ } else { return completion(.failure(.notImplemented)) }
        //if day < 2 { /* proceed */ } else { return completion(.failure(.notImplemented)) }
        
        fetcher = HolidayFetcher()
        fetcher?.fetch(url: url, completion: completion)
        
//        DispatchQueue.global().async { [weak self] in
//            self?.fetcher?.fetch(url: url, completion: completion)
//        }
    }
}
