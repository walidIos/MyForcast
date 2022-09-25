//
//  HomePageModel.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

struct HomePageModel {
    var fullListForcast: [WeatherResponse] = []
    var  filtredList: [WeatherResponse] = []
    var listCities: [ResultCity] = []
    var selectedCities: [CityModel] = []
}
