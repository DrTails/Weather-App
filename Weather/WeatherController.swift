//
//  WeatherController.swift
//  Weather
//
//  Created by Daniel Martinsson on 2018-04-06.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class WeatherController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate, FavoriteDelegate {

    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var clothingLabel: UILabel!
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "d9b572af1170e7d7ab0c07157c5a1e43"
    
    var cityList : [WeatherDataModel] = []
    var cityListFaves : [String] = []
    let defaults = UserDefaults.standard
    let key = "Favorites"
    
    
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherIcon.alpha = 0
        
        
        cityLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.adjustsFontSizeToFitWidth = true
        humidityLabel.adjustsFontSizeToFitWidth = true
        windSpeedLabel.adjustsFontSizeToFitWidth = true
        clothingLabel.adjustsFontSizeToFitWidth = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        cityListFaves = defaults.stringArray(forKey: "Favorites") ?? [String]()

        fade()
        
    }
    
    func fade() {
        UIView.animate(withDuration: 1.5, animations: {
            self.weatherIcon.alpha = 1.0
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success!")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    func updateWeatherData(json : JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            
            weatherDataModel.temperature = Int(tempResult - 273.15)
            
            weatherDataModel.city = json["name"].stringValue
            
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            
            weatherDataModel.wind = json["wind"]["speed"].floatValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            weatherDataModel.clothingTip = weatherDataModel.clothing(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°C"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        humidityLabel.text = "Humidity: \(weatherDataModel.humidity)%"
        windSpeedLabel.text = "Windspeed: \(weatherDataModel.wind) m/s"
        clothingLabel.text = "\(weatherDataModel.clothingTip)"
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    func userEnteredANewCityName(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    func favoriteCitySearch(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
            weatherIcon.alpha = 0
        }
        
        else if segue.identifier == "faves" {
            let destinationVC = segue.destination as! FavoritesViewController
            
            destinationVC.delegate = self
            
            destinationVC.faveCityList = cityListFaves
            weatherIcon.alpha = 0
            
        }
    }
    
    @IBAction func fave(_ sender: UIButton) {
        
        let faveCity = cityLabel.text
        
        if (cityListFaves.contains(faveCity!)) {
            
            let alert = UIAlertController(title: "Favorites", message: "\(faveCity!) is already a favorite!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
            print("Favorite already exists")
            print("Favorites: \(cityListFaves)")
            
        }
            
        else {
            
            cityList.append(weatherDataModel)
            cityListFaves.append(faveCity!)
            defaults.set(cityListFaves, forKey: key)
        
            print("Favorites: \(cityListFaves)")
            
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
