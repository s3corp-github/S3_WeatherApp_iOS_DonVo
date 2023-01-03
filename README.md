# S3_WeatherApp_iOS_DonVo

A Weather application tracking temperature by city Name. User can search for available cities and track temperature, humidity, condition, weather image.

- [Guideline](#guidelines)
- [Use Cases](#usecases)
  * [Use case 1](#usecase1)
  * [Use case 2](#usecase2)
  * [Use case 3](#usecase3)
  * [Use case 4](#usecase4)
  * [Use case 5](#usecase5)
- [Interface](#interface)
  * [Search Screen](#searchscreen)
  * [City Screen](#cityscreen)
- [Test Coverage](#testcoverage)
  * [Test Result](#testresult)
  * [Coverage](#coverage)
- [Tools and Technologies](#toolsandtechnologies)
- [References](#references)

## Guideline
- Xcode 13.0 compatible
- iOS 14.1 minimum deployments

## Use Cases
### Use Case 1
- As a user
- Given I am on the home screen
- When I type in to the search bar on the home page
- Then i will see a list of available cities that pattern matches what I have typed

### Use Case 2
- As a user
- Given I am on the home screen
- And there is a list of available cities (based on what I've typed) When I tap on a city
- Then I will be on the city Screen
- Then I will see the current weather image
- Then I will see the current humidity
- Then I will see the current weather in text form
- Then I will see the current weather temperature

### Use Case 3
- As a user
- Given I am on the home screen
- And I have not viewed a City's weather Then I should see a list view empty state

### Use Case 4
- As a user
- Given I am on the home screen
- And I have previously viewed any city's weather
- Then I should see an ordered list of the recent 10 cities that I have previously seen. And I should see the latest City that I have viewed at the top of the list

### Use Case 5
- As a user
- Given I have previously viewed any city's weather
- When I have relaunched the app (terminating the app and relaunched)
- Then I should see a ordered list of the recent 10 cities that I have previously seen.
- The reviewers will be looking out on whether you adhere to clean code practices and readability.

## Interface
### Search Screen
<p align="center">
 <img src="https://user-images.githubusercontent.com/43954674/210293886-6d04d388-c7bd-404e-8edc-f6e2a47f06f7.png" width="300">
 <img src="https://user-images.githubusercontent.com/43954674/210293871-41b76a12-73bd-473c-8ff2-e7397008042f.png" width="300">
 <img src="https://user-images.githubusercontent.com/43954674/210293909-3d01fb8e-47cf-4cbd-9e31-3195a0ec6c8b.png" width="300">
 <img src="https://user-images.githubusercontent.com/43954674/210293924-9189b3aa-3070-4d8d-8fa1-708e7655b746.png" width="300">
 <img src="https://user-images.githubusercontent.com/43954674/210293894-ab21ba7b-e3ab-4e62-8bec-f2b573ce6a3a.png" width="300">
</p>

### City Screen
<p align="center">
 <img src="https://user-images.githubusercontent.com/43954674/210294120-5f9635db-0bfe-4579-9f39-a8ec4a29f3b3.png" width="300">
</p>

## Tools and Technologies
- Swift 5
- Xcode 14
- Protocol-Oriented Programming
- MVVM Architecture
- Restful api
- Dependency Injection
- Caching
- Unit test with XCTest

## References
- Programming iOS 14 book - Oreilly
- iOS Test-Driven Developement by tutorials book - Raywenderlich
- [iOS Clean Architecture MVVM - kudoleh](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
- [Protocol Oriented Programming in Swift - Alicanbatur](https://medium.com/nsistanbul/protocol-oriented-programming-in-swift-ad4a647daae2)
- [Better REST API Management in Swift - Pablo Blanco](https://medium.com/swlh/better-api-management-in-swift-c2c1ad6354be)
- [Caching in Swift - Swift by Sundell](https://www.swiftbysundell.com/articles/caching-in-swift/)
- [UserDefaults Helper Class - Sujal Shrestha](https://suj9763.medium.com/userdefaults-helper-class-an-easy-way-to-use-userdefaults-334d8da30073)

