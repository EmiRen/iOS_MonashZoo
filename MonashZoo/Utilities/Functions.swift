//
//  Function.swift
//  MonashZoo
//
//  Created by Ren Jie on 22/8/18.
//  Copyright © 2018 JRen. All rights reserved.
//

import Foundation
import UIKit

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

let CoreDataSaveFailedNotification = Notification.Name(rawValue: "CoreDataSaveFailedNotification")

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}

func categoryIcon(_ animal: Animal) -> UIImage {
    switch animal.category{
    case "Dogs":
        return #imageLiteral(resourceName: "Dogs")
    case "Kangaroos":
        return #imageLiteral(resourceName: "Kangaroos")
    case "Birds":
        return #imageLiteral(resourceName: "Birds")
    case "Insects":
        return #imageLiteral(resourceName: "Insects")
    case "Fishes":
        return #imageLiteral(resourceName: "Fishes")
    case "Rabbits":
        return #imageLiteral(resourceName: "Rabits")
    case "Deers":
        return #imageLiteral(resourceName: "Deers")
    case "Pigs":
        return #imageLiteral(resourceName: "Pigs")
    case "Sheeps":
        return #imageLiteral(resourceName: "Sheeps")
    case "New Species FOUND!":
        return #imageLiteral(resourceName: "NewSpecies")
        
    default:
        return #imageLiteral(resourceName: "NoCategory")
    }
}

// Reference:
// All the images are picked from: https://icons8.com


