# CalendarAppU
Calendar app UIkit, InspiringApps coding challenge

The calendar does not stop at 3 years +/- current - did not implement to check.


The api chosen was  holidays.abstractapi.com/v1/
Free version 
1,000 requests
1 request / second

The Free version requires Y M and D.   Y and M would have been cool, but oh well.

![alt text](https://github.com/kerrjo/CalendarAppU/blob/master/Screen%20Shot%202022-01-27%20at%206.57.45%20PM.png)

This implementation considered this limited bandwidth for testing the code typically looks like this while testing the calendar wo api updates
simply return an error. It would build the URL but not send it
```
 if day < 1 { } else {
            return completion(.failure(.notImplemented)) }
```

Limited testing would only check for day one for each month.
```
 if day == 1 { } else {
            return completion(.failure(.notImplemented)) }
```
The service calls. There are two kinds of web service Objects HolidayWebService and HolidayServiceHandler

Both conform to `HolidayWebService` protocol
```
protocol HolidayWebService {
    func cancel()
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ())
}
```
Which one to use controlled by `serviceCalls()` method

```
private extension MonthViewModel {

    func serviceCalls() {
        print(#function)
        serviceCallsNonCancelling()
        // serviceCallsCancelling()
    }
```

The `HolidayService` is setup so that requests can be cancelled. In the hopes that cancelling might not waste requests.
a `dataTask: URLSessionDataTask` ivar is used to hold the single task for every day api call a new instance is used `HolidayService`
and stored, upon navigating to a new month all instances dataTasks' are cancelled.
```
public class HolidayService: HolidayWebService {
    private(set) var dataTask: URLSessionDataTask?
```

The second kind: `HolidayServiceHandler` and cannot cancel requests and only one instance is used so it is not stored. 
 
```
public class HolidayServiceHandler: HolidayWebService {
    static let shared = HolidayServiceHandler()
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ()) {
        
        guard var components = URLComponents(string: "https://holidays.abstractapi.com/v1/") else { return }
```

I typically, like to use a Singleton for something like this. Do not record the dataTask and use a pattern like 
```
  URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
            guard (200...299).contains(httpResponse.statusCode) else {
            
            completion(.success(results))
        }.resume()
   }  
```
In addition, the use of the single shared instance allows for dependency injection and unit testing of the fetch

Another technique to conserve requests was to change the URL
```
https://holidays.abstractapi_FOO.com/v1/
```
another was altering the key with underscores maybe
```
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "___f27cdac22cabd3f925d"),
            URLQueryItem(name: "country", value: "US"),
            URLQueryItem(name: "year", value: "\(year)"),
```

![alt text](https://github.com/kerrjo/CalendarAppU/blob/master/Screen%20Shot%202022-01-27%20at%206.57.56%20PM.png)
