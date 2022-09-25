//
//  CityLocationResponse.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

// MARK: - ResultCity
struct ResultCity: Codable {
    let name: String?
    let localNames: [String: String]?
    let lat, lon: Double
    let country, state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}
typealias CityLocationResponse = [ResultCity]
