//
//  HomeViewModel.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

protocol HomePageVMDelegate {
    func onLoadNewLists()
}

class HomePageVM {
    var delegate: HomePageVMDelegate?
    var model = HomePageModel()
    
    var weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository){
        self.weatherRepository = weatherRepository
        
    }
    
    func loadListCities() {
        self.model.selectedCities = []
        self.model.selectedCities.append(.init(id: 0,
                                               name: "Casablanca",
                                               subName: "Morocco",
                                               lon: 33.5928,
                                               lat: -7.6192))
        
        self.model.selectedCities.append(.init(id: 1,
                                               name: "Rabat",
                                               subName: "Morocco",
                                               lon: 33.9911,
                                               lat: -6.8401))
        
        self.model.selectedCities.append(.init(id: 2,
                                               name: "Tanger",
                                               subName: "Morocco",
                                               lon: 35.7806,
                                               lat: -5.8137))
        
        self.model.selectedCities.append(.init(id: 3,
                                               name: "Marrakech",
                                               subName: "Morocco",
                                               lon: 31.6315,
                                               lat: -8.0083))
    }
    
    /*
     This function will add city to the list via WorldWeatherApi
     */
    func addCityToList(city: ResultCity) {
        guard let name = city.name,
              let country = city.country else {
                  return
              }
        let lon: Float = Float(city.lon) ?? 0
        let lat: Float = Float(city.lat) ?? 0
        self.model.selectedCities.append(.init(id: generateCityId(),
                                               name: name,
                                               subName: country,
                                               lon: lon,
                                               lat: lat))
    }
    func generateCityId() -> Int {
        var id = 0
        while !self.model.selectedCities.filter({ $0.id == id }).isEmpty {
            id+=1
        }
       
        return id
    }
    /*
     This function to load all the cities in list of names
     */
    func loadListWeatherByCities() {
        weatherRepository.callGetListWeatherByListCities(list: self.model.selectedCities, completion: { success, list, error in
           
            self.model.fullListForcast = list
            self.model.filtredList = list
            
            self.delegate?.onLoadNewLists()
        })
    }
    
    /*
     This function will be used on the VC to the get the current list
     */
     func getListWeatherItems() -> [WeatherResponse] {
        return self.model.filtredList
    }
    
    /*
     This function will get an item at index
     */
    func getItemAtIndexOf(index: Int) -> WeatherResponse? {
        guard index >= 0 && index < self.model.filtredList.count else {
            return nil
        }
        return self.model.filtredList[index]
    }
    
    /*
     This function will remove an item at index
     */
    func removeItemAtIndexOf(index: Int){
        guard index >= 0 && index < self.model.filtredList.count else {
            return
        }
        let item = self.model.filtredList[index]
        self.model.filtredList = self.model.filtredList.filter({
            $0.id != item.id
        })
        self.model.fullListForcast = self.model.fullListForcast.filter({
            $0.id != item.id
        })
        self.model.selectedCities = self.model.selectedCities.filter({
            $0.id != item.id
        })
       
    }
    
    /*
     this function will be called when textField been changed and filter the fullList by name
     */
    func searchForCityWeaher(value: String) {
        guard !value.isEmpty else {
            self.model.filtredList = self.model.fullListForcast
            self.delegate?.onLoadNewLists()
            return
        }
        let value = value.lowercased()
        self.model.filtredList = self.model.fullListForcast.filter({
            $0.cityName.lowercased().contains(value) || $0.districtName.lowercased().contains(value)
        })
        self.delegate?.onLoadNewLists()
    }
}
