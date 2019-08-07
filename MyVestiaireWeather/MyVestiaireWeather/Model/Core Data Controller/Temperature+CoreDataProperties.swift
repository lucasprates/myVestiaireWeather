//
//  Temperature+CoreDataProperties.swift
//  
//
//  Created by Lucas on 07/08/2019.
//
//

import Foundation
import CoreData


extension Temperature {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Temperature> {
        return NSFetchRequest<Temperature>(entityName: "Temperature")
    }

    @NSManaged public var day: Double
    @NSManaged public var evening: Double
    @NSManaged public var maximum: Double
    @NSManaged public var minimum: Double
    @NSManaged public var morning: Double
    @NSManaged public var night: Double
    @NSManaged public var forecast: Forecast?

}
