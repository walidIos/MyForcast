//
//  WeatherRepository.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

protocol WeatherRepository {
    func callGetListWeatherByListCities(list: [CityModel],
                                        completion: @escaping((_ success: Bool,
                                                               _ list: [WeatherResponse],
                                                               _ error: String?) -> Void))
    func callGetListWeathersLonLat(lon: String,
                                   lat: String,
                                   completion: @escaping((_ success: Bool,
                                                          _ model: WeatherResponse?,
                                                          _ error: ApiError?) -> Void))
    func searchListCitiesByName(value: String, completion: @escaping((_ listCities: [ResultCity]) -> Void))
}
class WeatherRepositoryImp : WeatherRepository{
    //static let sharedInstance = WeatherRepository()
    private let httpClient: HttpClient
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    func callGetListWeatherByListCities(list: [CityModel],
                                        completion: @escaping((_ success: Bool,
                                                               _ list: [WeatherResponse],
                                                               _ error: String?) -> Void)) {
        var listWeather: [WeatherResponse] = []
        list.forEach { cityModel in
            self.callGetListWeathersLonLat(lon: "\(cityModel.lon)",
                                           lat: "\(cityModel.lat)") { _, model, error in
                var model = model
                model?.cityName = cityModel.name
                model?.id = cityModel.id
                model?.districtName = cityModel.subName
                
                listWeather.append(model ?? .init(id: -9999))
                if listWeather.count == list.count {
                    listWeather = listWeather.filter({$0.id != -9999})
                    completion(true, listWeather, error?.localizedDescription)
                }
            }
            
        }
    }
    
    func callGetListWeathersLonLat(lon: String,
                                   lat: String,
                                   completion: @escaping((_ success: Bool,
                                                          _ model: WeatherResponse?,
                                                          _ error: ApiError?) -> Void)) {
        let params: [String: Any] = [
            Constants.latKey: lat,
            Constants.lonKey: lon,
            Constants.unitsKey: "metric",
            Constants.apiIdKey: Constants.apiWeatherId
        ]
        let headers: [String: String] = [:]
        
        let apiURL = URL(string: Constants.getListWeathersPath)
        let apiRequest = ApiRequest(resource: apiURL!, method: .get,params: params)
        httpClient.request(apiRequest) { (result: Result<WeatherResponse, ApiError>) in
            switch result {
            case .success(let Weather):
                completion(true, Weather, nil)
            case .failure(let error):
                completion(false, nil, ApiError.serverError)
            }
        }
        
    }
    
    func searchListCitiesByName(value: String, completion: @escaping((_ listCities: [ResultCity]) -> Void)) {
        let params: [String: Any] = [
            Constants.citySearchKey: value,
            Constants.limitSearchKey: 5,
            Constants.apiIdKey: Constants.apiWeatherId,
            Constants.formatResponseKey: "json"
        ]
        let headers: [String: String] = [:]
       
        let apiURL = URL(string: Constants.pathSearchCity)
        let apiRequest = ApiRequest(resource: apiURL!, method: .get,params: params)
        httpClient.request(apiRequest) { (result: Result<[ResultCity], ApiError>) in
            switch result {
            case .success(let cities):
                completion(cities)
            case .failure(let error):
                completion([])
            }
        }
    }
}
