//
//  AnimalListViewController.swift
//  MonashZoo
//
//  Created by Ren Jie on 22/8/18.
//  Copyright © 2018 JRen. All rights reserved.
//
// References:
// 1. Adding a search feature with dynamic filtering:
//    https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
// 2. Enum-Driven TableView Development(not finish):
//    https://www.raywenderlich.com/5542-enum-driven-tableview-development


import UIKit
import CoreData
import CoreLocation
import MapKit


class AnimalListViewController: UITableViewController {
    
    // MARK: - Properties
    
    var mapViewController: MapViewController?
    var animals = [Animal]()
    var filteredAnimal = [Animal]()
    let searchController = UISearchController(searchResultsController: nil)
    var list = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    //add from tutorial5
    
    var managedObjectContext: NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController<Animal> = {
        let fetchRequest = NSFetchRequest<Animal>()
        let entity = Animal.entity()
        fetchRequest.entity = entity
        let sort1 = NSSortDescriptor(key: "category", ascending: true)
        let sort2 = NSSortDescriptor(key: "animalDescription", ascending: true)
        fetchRequest.sortDescriptors = [sort1,sort2]
//        fetchRequest.sortDescriptors = [sort1]
//        let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
//        switch scopeIndex {
//        case 0:
//            fetchRequest.sortDescriptors = [sort1]
//        case 1:
//            fetchRequest.sortDescriptors = [sort2]
//        default:
//            fetchRequest.sortDescriptors = [sort1]
//        }

        fetchRequest.fetchBatchSize = 20
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "category", cacheName: "Animals")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performFetch()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Animals"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor(red: 255.0/255.0, green: 123.0/255.0, blue: 134.0/255.0, alpha: 1.0)

        
        //add from candy
        animals = fetchedResultsController.fetchedObjects!
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            mapViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MapViewController
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
  
    }
    
    //add from candy
    override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed {
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("Received memory warning")
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddAnimal" {
            let controller = segue.destination as! FindLocationViewController
            controller.managedObjectContext = managedObjectContext
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return list
    }
    
    // MARK:- Private methods
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
 
    // MARK: - Table View Delegates
    //add t5
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectLocation: Animal
        if isFiltering() {
            selectLocation = filteredAnimal[indexPath.row]
        } else {
            selectLocation = fetchedResultsController.object(at: indexPath)
        }
        mapViewController?.focusOn(selectedLocation: selectLocation as MKAnnotation)
        splitViewController?.showDetailViewController(mapViewController!, sender: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if isFiltering() {
            //fix repeated problem add this line
            return 1
        }else{
            return fetchedResultsController.sections!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        if isFiltering() {
           return filteredAnimal.count
        }
        else{
            return sectionInfo.numberOfObjects
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section]
        if isFiltering() {
            return nil
        }else{
            return sectionInfo.name
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath) as! AnimalCell
        let animal: Animal
        if isFiltering() {
            animal = filteredAnimal[indexPath.row]
        } else {
            animal = fetchedResultsController.object(at: indexPath)
        }
        
        cell.configure(for: animal)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = fetchedResultsController.object(at: indexPath)
            location.removePhotoFile()
            managedObjectContext.delete(location)
            do {
                try managedObjectContext.save()
            } catch {
                fatalCoreDataError(error)
            }
        }
    }
}

// MARK:- NSFetchedResultsController Delegate Extension
extension AnimalListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            print("NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .update:
            print("NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!)
                as? AnimalCell {
                let animal = controller.object(at: indexPath!)
                    as! Animal
                cell.configure(for: animal)
            }
            
        case .move:
            print("NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controller(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            print("NSFetchedResultsChangeInsert (section)")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("NSFetchedResultsChangeDelete (section)")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            print("NSFetchedResultsChangeUpdate (section)")
        case .move:
            print("NSFetchedResultsChangeMove (section)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        tableView.endUpdates()
    }
    
    // MARK: - Private instance methods for searching
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //essential searching  ????error: multiple divides , maybe section prob
    func filterContentForSearchText(_ searchText: String, scope: String ) {
        
        animals = fetchedResultsController.fetchedObjects!
    
        filteredAnimal = animals.filter({( animal : Animal) -> Bool in
            return animal.animalDescription.contains(searchText)
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}


extension AnimalListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!, scope: "A-Z")
    }
}

