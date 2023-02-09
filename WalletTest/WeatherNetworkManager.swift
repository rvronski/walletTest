//
//  WeatherNetworkManager.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 09.02.2023.
//

import Foundation

struct Coords: Codable {
    var lon: Double
    var lat: Double
}

struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct Main: Codable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Double?
    var humidity: Double?
    var seaLevel: Int?
    var grndLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Wind: Codable {
    var speed: Double?
    var deg: Int?
    var gust: Double?
}

struct Rain: Codable {
    var oneH: Double?
    enum CodingKeys: String, CodingKey {
        case oneH = "1h"
    }
}

struct Clouds: Codable {
    var all: Int?
}

struct Sys: Codable {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
}

struct WheatherAnswer: Codable {
    var coord: Coords
    var weather: [Weather]
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var rain: Rain?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
    
}

func getNowWeather(lat:Double, lon: Double,  completion: @escaping (WheatherAnswer) -> Void) {
    let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=b896c16fafb3a47b68b0a51b99fa50f2&lang=ru&units=metric"
    guard let url = URL(string: urlString) else {return}
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, response, error in
        if let error {
            print(error.localizedDescription)
            return
        }
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        if statusCode != 200 {
            print("Status Code = \(String(describing: statusCode))")
            return
        }
        guard let data else {
            print("data = nil")
            return
        }
        do {
           let answer = try JSONDecoder().decode(WheatherAnswer.self, from: data)
            completion(answer)
            print(answer)
        } catch {
            print(error)
        }
    }
    task.resume()
}
