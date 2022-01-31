# CalendarAppU
Calendar app UIkit, InspiringApps coding challenge

Built with *Xcode Version 13.2.1 (13C100)*

![alt text](https://github.com/kerrjo/CalendarAppU/blob/master/Screen%20Shot%202022-01-29%20at%203.04.48%20AM.png)

## The service api
The api chosen was holidays.abstractapi.com/v1/
Free version only allows 1,000 requests 1 request / second

The Free version requires Y M and D.   Y and M would have been cool, but oh well.

## Usage

Before ripping through many months, tap happy, be aware there are limited requests available with the api key submitted.

And Because of the limited bandwidth, i considered cancelling service calls. Typically I like to use a shared instance to handle service requests. I implemented both and tested with both. Finally ended up with using the noncancelling version.

I have limited the days to specific days in `HolidayServiceHandler`
```
 if day < 4 || day > 22 { } else {
            return completion(.failure(.notImplemented)) }
```
I would prefer if you run the app, using the supplied api_key, that the days be limited like `day < 2` ( for only the first day)
or no days `day < 1` if flipping through many years.

- On the `master` branch day is set in `HolidayServiceHandler` non cancelling
- On the `paging` branch day is set in `HolidayService` cancelling

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
### NonCancelling service calls
The second kind: `HolidayServiceHandler` and cannot cancel requests and only one instance is used so it is not stored. 
```
public class HolidayServiceHandler: HolidayWebService {
    static let shared = HolidayServiceHandler()
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ()) {
      URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
            guard (200...299).contains(httpResponse.statusCode) else {
            
            completion(.success(results))
      }.resume()
```
### Cancelling service calls
The `HolidayService` is setup so that requests can be cancelled. In the hopes that cancelling might not waste requests. a `dataTask: URLSessionDataTask` ivar is used to hold the single task for every day api call a new instance is used `HolidayService` and stored, upon navigating to a new month all instances dataTasks' are cancelled.
```
public class HolidayService: HolidayWebService {
    private(set) var dataTask: URLSessionDataTask?
    
    func fetchHolidays(year: Int, month: Int, day: Int, completion: @escaping (Result<Holidays, FetchError>) -> ()) {    
       dataTask = URLSession.shared.dataTask(with: url) { data, response, error in            
```
## Testing
This implementation considered this limited bandwidth. For testing purposes code typically looks like this 
```
 if day < 1 { } else {
            return completion(.failure(.notImplemented)) }
```
test the calendar wo api updates it simply returns an error. It would build the URL but not send it.

Limited testing would only check for day one for each month.
```
 if day == 1 { } else {
            return completion(.failure(.notImplemented)) }
```
### Other testing
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

# Paging

Checkout the paging branch for navigation https://github.com/kerrjo/CalendarAppU/tree/Paging

pull request 
https://github.com/kerrjo/CalendarAppU/pull/2

On this branch, I have limited the days `day < 1` in `HolidayService` which will not submit any days.

I would prefer if you run the app, using the supplied api_key, that the days be limited like `day < 2` ( for only the first day)
or no days `day < 1` if flipping through many years.

The Cancelling service is good because on each new month, a new viewModel is created, and the the requests just go away, as do the arrays holding the holidays and services.


https://user-images.githubusercontent.com/12850537/151677177-bcde71d3-f5a7-4c75-851c-e69a47769892.mp4

well beyond 3 yrs

https://user-images.githubusercontent.com/12850537/151677459-fa63f659-ce76-48fa-87c1-a0ef5403a265.mp4

pretty cool

https://user-images.githubusercontent.com/12850537/151677849-4ef3be2b-e231-4162-b481-69265de6f582.mp4




