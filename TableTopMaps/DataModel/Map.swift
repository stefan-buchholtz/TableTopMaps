//
//  Map.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 26.09.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import Foundation

class Map: MapListElement {
    
    var name: String
    
    let subElements = [MapListElement]()
    
    let isLeaf = true
    
    init(name: String) {
        self.name = name
    }
}