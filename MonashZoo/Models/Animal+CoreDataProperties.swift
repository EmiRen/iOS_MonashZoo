//
//  Animal+CoreDataProperties.swift
//  MonashZoo
//
//  Created by Ren Jie on 22/8/18.
//  Copyright © 2018 JRen. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation


extension Animal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Animal> {
        return NSFetchRequest<Animal>(entityName: "Animal")
    }

    @NSManaged public var category: String
    @NSManaged public var date: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var animalDescription: String
    @NSManaged public var longitude: Double
    @NSManaged public var photoID: NSNumber?
    @NSManaged public var placemark: CLPlacemark?
    @NSManaged public var hasVisted: String
}
