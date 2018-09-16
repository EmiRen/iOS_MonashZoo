//
//  AppDelegate.swift
//  MonashZoo
//
//  Created by Ren Jie on 22/8/18.
//  Copyright © 2018 JRen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MonashZoo")
        container.loadPersistentStores(completionHandler: {
            storeDescription, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext =
        self.persistentContainer.viewContext
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(applicationDocumentsDirectory)
        
        let splitViewController = window!.rootViewController as! UISplitViewController
        splitViewController.delegate = self
        
        // first split - animalList
        var navController = splitViewController.viewControllers.first as! UINavigationController
        let animalList = navController.viewControllers.first as! AnimalListViewController
        animalList.managedObjectContext = managedObjectContext
        let _ = animalList.view
        
        // second split - mapView
        navController = splitViewController.viewControllers.last as! UINavigationController
        let mapView = navController.viewControllers.last as! MapViewController
        mapView.managedObjectContext = managedObjectContext
        
        splitViewController.preferredDisplayMode = .allVisible
        
        //add default 5 animals first launch
        if !UserDefaults.standard.bool(forKey: "launchedBefore") {
            self.insertDefaultData()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        listenForFatalCoreDataNotifications()
        return true
    }
    
    // MARK: - Split view delegate
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
//        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
//        guard let topAsMapController = secondaryAsNavController.topViewController as? MapViewController else { return false }
//        if topAsMapController.detailAnimal == nil {
//            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//            return true
//        }
//        return false
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK:- Helper methods
    func listenForFatalCoreDataNotifications() {
        NotificationCenter.default.addObserver(forName: CoreDataSaveFailedNotification, object: nil, queue: OperationQueue.main, using: { notification in
            let message = """
            There was a fatal error in the app and it cannot continue.

            Press OK to terminate the app. Sorry for the inconvenience.
            """
            let alert = UIAlertController(title: "Internal Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                let exception = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Fatal Core Data error", userInfo: nil)
                exception.raise()
            }
            alert.addAction(action)
            let tabController = self.window!.rootViewController!
            tabController.present(alert, animated: true, completion: nil)
        })
    }
    
    //TODO: add 5 default animals
    func insertDefaultData() {
        let default1 = Animal(context: managedObjectContext)
        default1.animalDescription = "Red Kangaroo"
        default1.category = "Kangaroos"
        default1.latitude = -37.878924
        default1.longitude = 145.040920
        default1.placemark = nil
        default1.hasVisted = "Not Visit Yet"
        
        let default2 = Animal(context: managedObjectContext)
        default2.animalDescription = "White Kangaroo"
        default2.category = "Kangaroos"
        default2.latitude = -37.877552
        default2.longitude = 145.040791
        default2.placemark = nil
        default2.hasVisted = "Not Visit Yet"
        
        let default4 = Animal(context: managedObjectContext)
        default4.animalDescription = "Yellow Kangaroo"
        default4.category = "Kangaroos"
        default4.latitude = -37.878902
        default4.longitude = 145.043435
        default4.placemark = nil
        default4.hasVisted = "Not Visit Yet"
        
        let default3 = Animal(context: managedObjectContext)
        default3.animalDescription = "Blue Butterfly"
        default3.category = "Insects"
        default3.latitude = -37.874898
        default3.longitude = 145.044658
        default3.placemark = nil
        default3.hasVisted = "Not Visit Yet"
        
        let default5 = Animal(context: managedObjectContext)
        default5.animalDescription = "White Rabit"
        default5.category = "Rabbits"
        default5.latitude = -37.876958
        default5.longitude = 145.043248
        default5.placemark = nil
        default5.hasVisted = "Not Visit Yet"
        
        let default6 = Animal(context: managedObjectContext)
        default6.animalDescription = "Black Rabit"
        default6.category = "Rabbits"
        default6.latitude = -37.876739
        default6.longitude = 145.044412
        default6.placemark = nil
        default6.hasVisted = "Not Visit Yet"
        
        let default7 = Animal(context: managedObjectContext)
        default7.animalDescription = "Parrot"
        default7.category = "Birds"
        default7.latitude = -37.878422
        default7.longitude = 145.045635
        default7.placemark = nil
        default7.hasVisted = "Not Visit Yet"
        
        let default8 = Animal(context: managedObjectContext)
        default8.animalDescription = "Peafowl"
        default8.category = "Birds"
        default8.latitude = -37.879353
        default8.longitude = 145.047169
        default8.placemark = nil
        default8.hasVisted = "Not Visit Yet"
        
        let default9 = Animal(context: managedObjectContext)
        default9.animalDescription = "Pink Pig"
        default9.category = "Pigs"
        default9.latitude = -37.877422
        default9.longitude = 145.046010
        default9.placemark = nil
        default9.hasVisted = "Not Visit Yet"
        
        let default10 = Animal(context: managedObjectContext)
        default10.animalDescription = "Golden Retriever"
        default10.category = "Dogs"
        default10.latitude = -37.876821
        default10.longitude = 145.047523
        default10.placemark = nil
        default10.hasVisted = "Not Visit Yet"
        
        let default11 = Animal(context: managedObjectContext)
        default11.animalDescription = "Clownfish"
        default11.category = "Fishes"
        default11.latitude = -37.875915
        default11.longitude = 145.041118
        default11.placemark = nil
        default11.hasVisted = "Not Visit Yet"
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
}

