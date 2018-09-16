//
//  Animal+CoreDataClass.swift
//  MonashZoo
//
//  Created by Ren Jie on 22/8/18.
//  Copyright © 2018 JRen. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit
import CoreLocation
import UIKit

@objc(Animal)
public class Animal: NSManagedObject, MKAnnotation {

    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    public var title: String? {
        if animalDescription.isEmpty {
            return "(No Description)"
        } else {
            return animalDescription
        }
    }
    
    public var subtitle: String? {
        return category
    }

    var hasVisit: String? {
        return hasVisted
    }

    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photoURL: URL {
        assert(photoID != nil, "No photo ID set")
        let filename = "Photo-\(photoID!.intValue).jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(currentID, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
    
    func removePhotoFile() {
        if hasPhoto {
            do {
                try FileManager.default.removeItem(at: photoURL)
            } catch {
                print("Error removing file: \(error)")
            }
        }
    }
    
}
