//
//  FavoritesViewController.swift
//  Weather
//
//  Created by Daniel Martinsson on 2018-04-08.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol FavoriteDelegate {
    func favoriteCitySearch(city : String)
}

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "d9b572af1170e7d7ab0c07157c5a1e43"
    
    var faveCityList : [String] = []
    var delegate : FavoriteDelegate?
    
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(faveCityList)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return faveCityList.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        let params : [String : String] = ["q" : faveCityList[indexPath.row], "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params, cell: cell)
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = faveCityList[indexPath.row]
        delegate?.favoriteCitySearch(city: cityName)
        navigationController?.popViewController(animated: true)
        
    }
    
    func getWeatherData(url: String, parameters: [String: String], cell : CustomTableViewCell) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success!")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON, cell: cell)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                cell.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    func updateWeatherData(json : JSON, cell : CustomTableViewCell) {
        
        if let tempResult = json["main"]["temp"].double {
            
            weatherDataModel.temperature = Int(tempResult - 273.15)
            
            weatherDataModel.city = json["name"].stringValue
            
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            
            
            cell.cityLabel.text = weatherDataModel.city
            cell.temperatureLabel.text = "\(weatherDataModel.temperature)°"
            cell.weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
            cell.cityLabel.adjustsFontSizeToFitWidth = true
        }
        else {
            cell.cityLabel.text = "Weather Unavailable"
        }
    }
    
    func updateUIWithWeatherData(cell : CustomTableViewCell) {
        cell.cityLabel.text = weatherDataModel.city
        cell.temperatureLabel.text = "\(weatherDataModel.temperature)°"
        cell.weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}
