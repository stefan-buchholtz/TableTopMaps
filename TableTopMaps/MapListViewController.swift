//
//  MapListViewController.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 26.09.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import UIKit
import CoreData

class MapListViewController: UITableViewController {
    
    var detailViewController: MapViewController? = nil
    var editMode = false
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: "newMapTapped:")
    let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let addFolderButton = UIBarButtonItem(title: "Neuer Ordner", style: .Plain, target: nil, action: "newFolderTapped:")
    let selectAllButton = UIBarButtonItem(title: "Alle markieren", style: .Plain, target: nil, action: "selectAll:")
    let moveButton = UIBarButtonItem(title: "Bewegen…", style: .Plain, target: nil, action: "moveTapped:")
    let deleteButton = UIBarButtonItem(title: "Löschen", style: .Plain, target: nil, action: "deleteTapped:")
    
    lazy var model: TableTopMapsDataModel = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).dataModel
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.model.managedObjectContext
    }()
    
    var selection = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let parent = currentParent() {
            title = parent.name
        } else {
            title = "Karten"
        }
        self.navigationItem.rightBarButtonItem = editButtonItem();
        addButton.target = self
        addFolderButton.target = self
        selectAllButton.target = tableView
        moveButton.target = self
        deleteButton.target = self
        
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MapViewController
        }
        validateControls()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        editMode = editing
        validateControls()
    }
    
    func validateControls() {
        if (editMode) {
            self.toolbarItems = [selectAllButton, spacer, moveButton, spacer, deleteButton]
            let hasSelection = tableView.indexPathForSelectedRow != nil
            moveButton.enabled = hasSelection
            deleteButton.enabled = hasSelection
        } else {
            self.toolbarItems = [addButton, spacer, addFolderButton]
        }
    }

    func newMapTapped(sender: AnyObject) {
        getName("Name der Karte", message: "Bitte geben Sie einen Namen für die neue Karte an.", callback: newMap)
    }
    
    func newMap(name: String) {
        let newMap = NSEntityDescription.insertNewObjectForEntityForName("Map", inManagedObjectContext: managedObjectContext) as! Map
        newMap.name = name
        if let parentFolder = currentParent() as? MapFolder {
            newMap.parent = parentFolder
            parentFolder.addMapsObject(newMap)
        }
        model.saveContext()
        self.reloadData()
    }
        func newFolderTapped(sender: AnyObject) {
        getName("Name des Ordners", message: "Bitte geben Sie einen Namen für den neuen Ordner an.", callback: newFolder)
    }
    
    func newFolder(name: String) {
        let newFolder = NSEntityDescription.insertNewObjectForEntityForName("MapFolder", inManagedObjectContext: managedObjectContext) as! MapFolder
        newFolder.name = name
        
        if let parentFolder = currentParent() as? MapFolder {
            newFolder.parent = parentFolder
            parentFolder.addSubFoldersObject(newFolder)
        }
        model.saveContext()
        self.reloadData()
    }
    
    func deleteTapped(sender: AnyObject) {
        if let selection = tableView.indexPathsForSelectedRows {
            let selectedObjects = selection.map(self.objectForIndexPath)
            for object in selectedObjects {
                if let managedObject = object as? NSManagedObject {
                    managedObjectContext.deleteObject(managedObject)
                }
            }
            model.saveContext()
            self.reloadData()
        }
    }
    
    func moveTapped(sender: AnyObject) {
        performSegueWithIdentifier("selectFolder", sender: self)
    }
    
    func getName(prompt: String, message: String?, callback: (String) -> Void) {
        let ac = UIAlertController(title: prompt, message: message, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "OK", style: .Default) { [unowned ac] (action: UIAlertAction!) in
            let answerField = ac.textFields![0]
            callback(answerField.text!)
        }
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil)
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        presentViewController(ac, animated: true, completion: nil)
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow where segue.identifier == "showMap" && !editMode {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! MapViewController
            controller.map = objectForIndexPath(indexPath) as? Map
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentElementList().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MapTableViewCell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mapElement = objectForIndexPath(indexPath)
        if (!editMode) {
            if mapElement is MapFolder {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyBoard.instantiateViewControllerWithIdentifier("mapList") as! MapListViewController
                controller.selection = selection + [indexPath.row]
                navigationController?.pushViewController(controller, animated: true)
            } else if mapElement is Map {
                self.performSegueWithIdentifier("showMap", sender: self)
            }
        } else {
            validateControls()
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if (editMode) {
            validateControls()
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let object = self.objectForIndexPath(indexPath) as? NSManagedObject {
                managedObjectContext.deleteObject(object)
                model.saveContext()
            }
        }
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let map = objectForIndexPath(indexPath)
        if let map = map {
            cell.textLabel!.text = map.name
            cell.accessoryType = map is MapFolder ? .DisclosureIndicator : .None
        }
    }
    
    /*
    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             //print("Unresolved error \(error), \(error.userInfo)")
             abort()
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    */

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */
    
    func reloadData() {
        model.loadMaps()
        tableView.reloadData()
    }
    
    func currentParent() -> MapListElement? {
        var result: MapListElement?
        var list = model.maps
        for idx in selection {
            result = list[idx]
            list = result!.subElements
        }
        return result
    }
    
    func currentElementList() -> [MapListElement] {
        if let parent = currentParent() {
            return parent.subElements
        } else {
            return model.maps
        }
    }
    
    func objectForIndexPath(indexPath: NSIndexPath) -> MapListElement? {
        return currentElementList()[indexPath.row]
    }

}

