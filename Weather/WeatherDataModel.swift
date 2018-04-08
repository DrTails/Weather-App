//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Daniel Martinsson on 2018-04-02.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import UIKit

class WeatherDataModel {
    
    var temperature : Int = 0
    var condition : Int = 0
    var city : String = ""
    var weatherIconName : String = ""
    var humidity : Int = 0
    var wind : Float = 0
    var clothingTip : String = ""
    
    //This method turns a condition code into the name of the weather condition image
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
    
    func clothing(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "A light thunderstorm, bring an umbrella!"
            
        case 301...500 :
            return "Just some light rain outside, wear a jacket!"
            
        case 501...600 :
            return "It's pouring out! Wear a raincoat!"
            
        case 601...700 :
            return "It's snowing out, better wear a coat!"
            
        case 701...771 :
            return "A bit foggy out, wear a jacket!"
            
        case 772...799 :
            return "Did you hear that thunder? Better wear a raincoat!"
            
        case 800 :
            return "The sun is shining brightly, use sunglasses!"
            
        case 801...804 :
            return "Cloudy outside, a jacket should be enough!"
            
        case 900...903, 905...1000  :
            return "Did you hear that thunder? Better wear a raincoat!"
            
        case 903 :
            return "It's snowing so much! Hope you got a warm coat!"
            
        case 904 :
            return "It's nice and warm out, wear something light!"
            
        default :
            return "I have no idea what the outside looks like!"
        }
    }
    
}
