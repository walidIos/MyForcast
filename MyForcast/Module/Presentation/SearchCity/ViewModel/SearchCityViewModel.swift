//
//  SearchCityViewModel.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

class SearchCityViewModel {
    
    var model = SearchCityModel()
    var weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository){
        self.weatherRepository = weatherRepository
    }
    
    func searchForCityByName(value: String, completion: @escaping(() -> Void)) {
        weatherRepository.searchListCitiesByName(value: value) { listCities in
            self.model.listCities = listCities
            completion()
        }
    }
    
    /*
     This function will be used on the VC to the get the current list
     */
    func getListCitiesItems() -> [ResultCity] {
        return self.model.listCities
    }
    
    /*
     This function will get an item at index
     */
    func getItemAtIndexOf(index: Int) -> ResultCity? {
        guard index >= 0 && index < self.model.listCities.count else {
            return nil
        }
        return self.model.listCities[index]
    }
}
