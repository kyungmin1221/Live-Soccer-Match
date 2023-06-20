//
//  WeatherData.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/19.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    struct Main: Codable {
        let temp: Double
    }
    let name: String
}



