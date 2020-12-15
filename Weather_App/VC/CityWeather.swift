//
//  CityWeather.swift
//  Weather_App
//
//  Created by Roman Kantor on 2020-11-26.
//  Copyright © 2020 Roman Kantor. All rights reserved.
//

import UIKit

class CityWeather: UIViewController {
    var locationToDisplay : FavLocation?
    var myModel : DataModelManager?
    
    @IBOutlet weak var screenTitle: UINavigationItem!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feels_like: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenTitle.title = locationToDisplay?.city
        fetchWeather()
    }
    
    
    // completion handler for the weather icon
    func fetchIcon (key: String) {
        myModel?.fetchWeatherIcon(key: key){ imageData in
            DispatchQueue.main.async {
                self.icon.image = UIImage(data: imageData as Data)
            }
        }
    }
    
    // completion handler for the fetchWeather API
    func fetchWeather() {
        let city = locationToDisplay?.city!.replacingOccurrences(of: " ", with: "%20")
        myModel?.fetchWeather(city: city ?? "") { (weatherInfo) in
            DispatchQueue.main.async {
                self.location.text = "\(self.locationToDisplay?.city as! String)"
                self.parseWeatherData(weatherInfo: weatherInfo)
            }
        }
    }
    
    // parse the weather data into labels
    func parseWeatherData(weatherInfo: NSDictionary) {
        
        // access the weather description part of the info
        let weatherDescription = weatherInfo["weather"]
       
        // extract the icon and description
        if let weatherResult = weatherDescription as? NSArray {
            let weather = weatherResult[0] as? Dictionary<String,Any>
            self.fetchIcon(key: weather?["icon"] as! String)
           
            self.weatherDescription.text = weather?["main"] as! String
          
        }
        
        // extract the main temperature section from the weather data
        let main = weatherInfo["main"] as! Dictionary<String,Any>
        
        // extract feels like temperature
        if let feelsLikeResult = main["feels_like"] as? NSNumber {
            // convert kelvin to celsius
            let feelsLike = Double(truncating: feelsLikeResult) - 273.15
            self.feels_like.text = "\(Int(feelsLike))°"
        }
        // extract acutal temperature
        if let tempResult = main["temp"] as? NSNumber {
            // convert kelvin to celsius
            let temp = Double(truncating: tempResult) - 273.15
            self.temp.text = "\(Int(temp))°"
        }

        // extract humidity level
        if let humidityResult = main["humidity"] as? NSNumber {
            self.humidity.text = "\(humidityResult)%"
        }
        
    }
    
}
