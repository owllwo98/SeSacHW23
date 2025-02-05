//
//  weather.swift
//  SeSacHW23
//
//  Created by 변정훈 on 2/3/25.
//

import Foundation

struct Weather: Decodable {
    let main: MainResult
    let wind: WindResult
}

struct MainResult: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}

struct WindResult: Decodable {
    let speed: Double
}
