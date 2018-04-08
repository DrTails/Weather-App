//
//  ChangeCityViewController.swift
//  Weather
//
//  Created by Daniel Martinsson on 2018-04-07.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName (city : String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBAction func SearchPressed(_ sender: AnyObject) {
        
        let cityName = cityTextField.text!
        
        delegate?.userEnteredANewCityName(city: cityName)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
