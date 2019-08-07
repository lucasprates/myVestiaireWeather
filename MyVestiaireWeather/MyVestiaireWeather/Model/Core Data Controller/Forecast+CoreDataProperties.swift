//
//  Forecast+CoreDataProperties.swift
//  
//
//  Created by Lucas on 07/08/2019.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var clouds: Int32
    @NSManaged public var date: NSDate?
    @NSManaged public var degree: Double
    @NSManaged public var descriptionText: String?
    @NSManaged public var humidity: Double
    @NSManaged public var iconName: String?
    @NSManaged public var mainText: String?
    @NSManaged public var pressure: Double
    @NSManaged public var speed: Double
    @NSManaged public var location: Location?
    @NSManaged public var temperature: Temperature?

}
