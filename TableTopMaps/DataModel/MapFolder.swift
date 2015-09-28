//
//  MapFolder.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 26.09.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import Foundation

class MapFolder {
    
    var name: String
    
    var subElements = [MapListElement]()
    
    let isLeaf = false
    
    init(name: String) {
        self.name = name
    }
    
}