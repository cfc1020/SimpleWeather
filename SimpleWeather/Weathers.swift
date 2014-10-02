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
}
