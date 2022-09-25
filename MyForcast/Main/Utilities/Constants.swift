//
//  Constants.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

class Constants {
    static let apiWeatherId         = "5d39406e9c6a057a30818ebece1667da"
    
    static let baseUrl              = "https://api.openweathermap.org/"
    static let pathImgIcon          = "https://openweathermap.org/img/wn/**_**@2x.png"
    static let getListWeathersPath  = baseUrl + "data/2.5/onecall"
    static let pathSearchCity       = baseUrl + "geo/1.0/direct"
    
    static let msgErrorServer       = "Erreur Server"
    
    static let latKey               = "lat"
    static let lonKey               = "lon"
    static let apiIdKey             = "appid"
    static let unitsKey             = "units"
    
    static let citySearchKey        = "q"
    static let formatResponseKey    = "format"
    static let worldWeatherApiKey   = "key"
    static let limitSearchKey       = "limit"
    
}
