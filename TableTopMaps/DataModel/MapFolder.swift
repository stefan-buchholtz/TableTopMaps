//
//  MapFolder.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 26.09.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import Foundation
import CoreData

class MapFolder: NSManagedObject, MapListElement {
    
    @NSManaged var name: String
    @NSManaged var parent: MapFolder?
    
    @NSManaged var subFolders: NSSet
    @NSManaged func addSubFoldersObject(subFolder: MapFolder)
    @NSManaged func removeSubFoldersObject(subFolder: MapFolder)
    @NSManaged func addSubFolders(subFolders: NSSet)
    @NSManaged func removeSubFolders(subFolders: NSSet)
    
    @NSManaged var maps: NSSet
    @NSManaged func addMapsObject(map: Map)
    @NSManaged func removeMapsObject(map: Map)
    @NSManaged func addMaps(maps: NSSet)
    @NSManaged func removeMaps(maps: NSSet)
    
    var subElements: [MapListElement] {
        var elems = [MapListElement]()
        elems.appendCompatibleElementsOf(subFolders.allObjects)
        elems.appendCompatibleElementsOf(maps.allObjects)
        elems.sortInPlace({ $0.name < $1.name })
        return elems
    }
    
    var level: Int {
        var result = 0
        var parent = self.parent
        while parent != nil {
            result++
            parent = parent?.parent
        }
        return result
    }
    
    let isLeaf = false
        
}