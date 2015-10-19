//
//  Map.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 26.09.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import Foundation
import CoreData

class Map: NSManagedObject, MapListElement {
    
    @NSManaged var name: String
    @NSManaged var parent: MapFolder?
    
    let subElements = [MapListElement]()
    
    let isLeaf = true
    
}