//
//  WeatherMng.swift
//  SimpleWeather
//
//  Created by Andrey on 23.09.14.
//  Copyright (c) 2014 Andrey. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class weather: NSObject {
    var city: String = "Un-name"
    var temp: String  = "0.0"
    var condition: String = "Un"
    
    //@IBOutlet var tblWeathers: UITableView!
    
    init(city_: String) {
        city = city_
    }
    
    init(city_: String, temp_: String, condition_: String) {
        city = city_
        condition = condition_
        temp = temp_
    }
    
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
                //println("JSON: " + responseObject.description!)
                
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
                    self.save()
                    return
                }
            }
        }
        }
    }
    
    func save() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Weathers")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "city = %@", city)
        
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if (results.count > 0) {
            //println("QAZ-------QAZ")
            for weather in results {
                let w = weather as Weathers
                w.condition = condition
                w.temp = temp
            }
        }
        else {
            let ent = NSEntityDescription.entityForName("Weathers", inManagedObjectContext: context)
            
            var newWeather = Weathers(entity: ent!, insertIntoManagedObjectContext: context)
            
            newWeather.city = city
            newWeather.temp = temp
            newWeather.condition = condition
        }
        context.save(nil)
    }
}

var weatherMng: WeatherManager = WeatherManager()

class WeatherManager: NSObject {
    var weathers = [weather]()
    
    func addTCityNotStored(city: String, temp: String, condition: String) {
        weathers.append(weather(city_: city, temp_: temp, condition_: condition))
    }
    
    
    
    func addCity(city: String) {
        var w = weather(city_: city)
        
        w.updateWeatherInfo()
        
        weathers.append(w)
        
        //let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        //let context: NSManagedObjectContext = appDel.managedObjectContext!
        //let ent = NSEntityDescription.entityForName("Weathers", inManagedObjectContext: context)
        
        //var newWeather = Weathers(entity: ent!, insertIntoManagedObjectContext: context)
        
        //newWeather.city = w.city
        //newWeather.temp = w.temp
        //newWeather.condition = w.condition
        
        //context.save(nil)
        //println(newTask)
    }
    
    func dumpWeathers() {
        
    }
}
