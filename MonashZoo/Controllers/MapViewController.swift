//
//  MapViewController.swift
//  MonashZoo
//
//  Created by Ren Jie on 22/8/18.
//  Copyright © 2018 JRen. All rights reserved.
//
//  References:
//  1.   How to use the MapKit framework to display real-world points:
//       https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
//  2.   Week 5 Tutorial: Apple Maps, Location & UISplitView
//       https://moodle.vle.monash.edu/pluginfile.php/7144642/mod_resource/content/3/W05a%20-%20MapKit%20%20Geolocation.pdf
//  3.   All the images are picked from:
//       https://icons8.com

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var animals = [Animal]()
    var locationManager = CLLocationManager()
    var geoLocation: CLCircularRegion?
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext, queue: OperationQueue.main) { notification in
                if self.isViewLoaded {
                    self.updateAnimals()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        self.mapView.mapType = MKMapType.standard
        super.viewDidLoad()
        setDefaultPosition()
        updateAnimals()
        
        
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditAnimal" {
            let controller = segue.destination as! AnimalDetailsViewController
            controller.managedObjectContext = managedObjectContext
            let button = sender as! UIButton
            let animal = animals[button.tag]
            controller.animalToEdit = animal
        }
        if segue.identifier == "ViewAnimals" {
            let controller = segue.destination as! AnimalListViewController
            controller.managedObjectContext = managedObjectContext
        }
    }
    
    // MARK:- Actions
    @IBAction func showUser() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    // MARK:- Private Methods
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //  @IBAction func showLocations() {
    //    let theRegion = region(for: locations)
    //    mapView.setRegion(theRegion, animated: true)
    //  }
    
    // MARK:- Private methods
    func setDefaultPosition() {
        let visibleRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: -37.876849, longitude: 145.043924), 800, 800)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
    }
    
    func addAnnotation() {
        mapView.addAnnotations(animals)
    }
    
    func updateAnimals() {
        mapView.removeAnnotations(animals)
        let entity = Animal.entity()
        let fetchRequest = NSFetchRequest<Animal>()
        fetchRequest.entity = entity
        animals = try! managedObjectContext.fetch(fetchRequest)
        addAnnotation()   //add from tutorial5
        
        
    }
    
    func focusOn(selectedLocation: MKAnnotation) {
        mapView.centerCoordinate = selectedLocation.coordinate
        mapView.selectAnnotation(selectedLocation, animated: true)
        print("!!!!!!!!!!!!hi there")
    }

    
    @objc func showAnimalDetails(_ sender: UIButton) {
        performSegue(withIdentifier: "EditAnimal", sender: sender)
    }

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Animal else {
            return nil
        }
        let identifier = "Animal"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {

            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView.isEnabled = true
            pinView.canShowCallout = true

            //for pop up box
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(showAnimalDetails), for: .touchUpInside)
            pinView.rightCalloutAccessoryView = rightButton
            annotationView = pinView
        }
        if let annotationView = annotationView {
            annotationView.annotation = annotation
            //for pop up box
            let button = annotationView.rightCalloutAccessoryView as! UIButton

            if let index = animals.index(of: annotation as! Animal) {
                button.tag = index
            }
            
            let animal = annotation as? Animal
            if animal?.hasVisit == "Not Visit Yet"{
                annotationView.image = #imageLiteral(resourceName: "icons8-pink-cute-folder-49")
            }else{
                annotationView.image = categoryIcon(animal!)
            }
            
            geoLocation = CLCircularRegion(center: (animal?.coordinate)!, radius: 100, identifier: (animal?.animalDescription)!)
            geoLocation!.notifyOnExit = true
            geoLocation!.notifyOnEntry = true
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoring(for: geoLocation!)
            
        }

        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let alert = UIAlertController(title: "Movement Detected", message: "You have left \(String(describing: geoLocation!.identifier)) area!" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alert = UIAlertController(title: "Movement Detected!", message: "You have left \(String(describing: geoLocation!.identifier)) area!" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
}



