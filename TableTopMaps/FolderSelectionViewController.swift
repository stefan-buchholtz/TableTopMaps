//
//  FolderSelectionViewController.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 18.10.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import UIKit

class FolderSelectionViewController: UITableViewController {
    
    weak var mapListViewController: MapListViewController?
    
    lazy var model: TableTopMapsDataModel = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).dataModel
    }()
    
    lazy var folders: [MapFolder] = {
        return self.model.allFolders()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelSelection:")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelSelection(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func folderForIndexPath(indexPath: NSIndexPath) -> MapFolder? {
        if indexPath.row > 0 {
            return folders[indexPath.row - 1]
        } else {
            return nil
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FolderSelectionViewCell", forIndexPath: indexPath)
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }

    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        if let folder = folderForIndexPath(indexPath) {
            cell.textLabel?.text = folder.name
            cell.indentationLevel = folder.level + 1
            cell.indentationWidth = 20.0
        } else {
            cell.textLabel?.text = "Karten"
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mapListViewController?.moveSelectedItemsTo(folderForIndexPath(indexPath))
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
