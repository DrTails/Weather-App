//
//  CustomTableViewCell.swift
//  Weather
//
//  Created by Daniel Martinsson on 2018-04-07.
//  Copyright © 2018 Daniel Martinsson. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
