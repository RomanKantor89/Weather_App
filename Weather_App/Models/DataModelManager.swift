//
//  DataModelManager.swift
//  Weather_App
//
//  Created by Roman Kantor on 2020-11-25.
//  Copyright © 2020 Roman Kantor. All rights reserved.
//

import Foundation

class DataModelManager {
    var searchResult = [Location]()
    
    // API to fetch the available loactions based on auto complete search
    func fetchLocation(key :String , handler : @escaping ([String])->Void) {
        
         guard let myUrl = URL(string: "http://gd.geobytes.com/AutoCompleteCity?callback=&q=\(key)") else {return}
        print(myUrl)
        URLSession.shared.dataTask(with: myUrl) { (data, request, error) in
         
            if let _ = error {return}
            guard let httpResponse = request as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
                else {
                    // Show the URL and response status code in the debug console
                    if let httpResponse = request as? HTTPURLResponse {
                        print("URL: \(httpResponse.url!.path )\nStatus code: \(httpResponse.statusCode)")
                    }
                    return
                }
                                               
              if let myData = data{
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: myData, options: []) as! [String]
                    // call the completion handler
                    handler(jsonObject)
                }catch {
                    print("error parsing JSON from locations")
                }
            }
            
        }.resume()
    }
    
    var API_KEY = "02416ea5998ee6d2d49c995c567740ea"
    // API to fetch the weather for a specific location
    func fetchWeather(city :String , handler : @escaping (NSDictionary)->Void) {
        
        guard let myUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(API_KEY)") else {return}
        print(myUrl)
        URLSession.shared.dataTask(with: myUrl) { (data, request, error) in
         
            if let _ = error {return}
            guard let httpResponse = request as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
                else {
                    // Show the URL and response status code in the debug console
                    if let httpResponse = request as? HTTPURLResponse {
                        print("URL: \(httpResponse.url!.path )\nStatus code: \(httpResponse.statusCode)")
                    }
                    return
                }
                                               
              if let myData = data{
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: myData, options: []) as! NSDictionary
                    // call the completion handler
                    handler(jsonObject)
                    
                }catch {
                    print("error parsing JSON from weather")
                }
                        
            }
            
        }.resume()
    }
    
    // API to fetch the icon for the weather
    func fetchWeatherIcon(key :String , handler : @escaping (Data)->Void) {
        
         guard let myUrl = URL(string: "https://openweathermap.org/img/wn/\(key)@2x.png") else {return}
        print(myUrl)
        URLSession.shared.dataTask(with: myUrl) { (data, request, error) in
         
            if let _ = error {return}
            guard let httpResponse = request as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
                else {
                    // Show the URL and response status code in the debug console
                    if let httpResponse = request as? HTTPURLResponse {
                        print("URL: \(httpResponse.url!.path )\nStatus code: \(httpResponse.statusCode)")
                    }
                    return
                }
                                               
              if let myData = data{
            
                // call the completion handler
                handler(myData)
            }
            
        }.resume()
    }
    
}


