//
//  Weathers.swift
//  SimpleWeather
//
//  Created by Andrey on 23.09.14.
//  Copyright (c) 2014 Andrey. All rights reserved.
//

import Foundation
import CoreData

@objc(Weathers)
class Weathers: NSManagedObject {

    @NSManaged var city: String
    @NSManaged var temp: String
    @NSManaged var condition: String
    
    
    func updateWeatherInfo() {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        println(url)
        
        let params = ["q": self.city]
        println(params)
        
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("JSON: " + responseObject.description!)
                
                self.updateSuccess(responseObject as NSDictionary!)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    
    func updateSuccess(jsonResult: NSDictionary!) {
        if jsonResult.objectForKey("main") != nil {
            if let tempResult = ((jsonResult["main"]? as NSDictionary)["temp"] as? Double) {
                
                // If we can get the temperature from JSON correctly, we assume the rest of JSON is correct.
                var temperature: Double
                if let sys = (jsonResult["sys"]? as? NSDictionary) {
                    if let country = (sys["country"] as? String) {
                        if (country == "US") {
                            // Convert temperature to Fahrenheit if user is within the US
                            temperature = round(((tempResult - 273.15) * 1.8) + 32)
                        }
                        else {
                            // Otherwise, convert temperature to Celsius
                            temperature = round(tempResult - 273.15)
                        }
                        
                        self.temp = "\(temperature)°"
                    }
                    
                    if let name = jsonResult["name"] as? String {
                        city = name
                    }
                    
                    if let weather = jsonResult["weather"]? as? NSArray {
                        condition = (weather[0] as NSDictionary)["description"] as String
                        NSNotificationCenter.defaultCenter().postNotificationName("updateTable", object: self)
                        return
                    }
                }
            }
        }
    }
}
