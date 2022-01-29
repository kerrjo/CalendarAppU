# CalendarAppU
Calendar app UIkit, InspiringApps coding challenge

Built with *Xcode Version 13.2.1 (13C100)*

The api chosen was holidays.abstractapi.com/v1/
Free version only allows 1,000 requests 1 request / second

The Free version requires Y M and D.   Y and M would have been cool, but oh well.

![alt text](https://github.com/kerrjo/CalendarAppU/blob/master/Screen%20Shot%202022-01-29%20at%203.04.48%20AM.png)

This implementation considered this limited bandwidth. For testing purposes code typically looks like this 
```
 if day < 1 { } else {
            return completion(.failure(.notImplemented)) }
```
while testing the calendar wo api updates it simply returns an error. It would build the URL but not send it.


Limited testing would only check for day one for each month.
```
 if day == 1 { } else {
            return completion(.failure(.notImplemented)) }
```
## The service calls
There are two kinds of web service Objects `HolidayWebService` and `HolidayServiceHandler`

Both conform to `HolidayWebService` protocol
```
protocol HolidayWebService {
    func cancel()
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ())
}
```
Which one to use is controlled by `serviceCalls()` method
```
private extension MonthViewModel {
    func serviceCalls() {
        serviceCallsNonCancelling()
        // serviceCallsCancelling()
```

### Cancelling service calls
The `HolidayService` is setup so that requests can be cancelled. In the hopes that cancelling might not waste requests. a `dataTask: URLSessionDataTask` ivar is used to hold the single task for every day api call a new instance is used `HolidayService` and stored, upon navigating to a new month all instances dataTasks' are cancelled.
```
public class HolidayService: HolidayWebService {
    private(set) var dataTask: URLSessionDataTask?
```

### NonCancelling service calls
The second kind: `HolidayServiceHandler` and cannot cancel requests and only one instance is used so it is not stored. 
```
public class HolidayServiceHandler: HolidayWebService {
    static let shared = HolidayServiceHandler()
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ()) {
        
        guard var components = URLComponents(string: "https://holidays.abstractapi.com/v1/") else { return }
```

I typically, like to use a Singleton for something like this. It does not record the `dataTask` and instead uses a pattern like 
```
  URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
            guard (200...299).contains(httpResponse.statusCode) else {
            
            completion(.success(results))
  }.resume()
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
```


good testcoverage

![alt text](https://github.com/kerrjo/CalendarAppU/blob/master/Screen%20Shot%202022-01-27%20at%208.11.00%20PM.png)
