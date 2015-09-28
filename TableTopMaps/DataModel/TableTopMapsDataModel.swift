//
//  ModelBase.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 28.09.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import Foundation

class TableTopMapsDataModel {
    
    var maps = [MapListElement]()
    
    init() {
        
    }
    
    func allMaps() -> [Map] {
        return walkMaps(maps)
    }
    
    private func walkMaps(maps: [MapListElement]) -> [Map] {
        return maps.flatMap({ (mapElem: MapListElement) -> [Map] in
            if mapElem.isLeaf {
                return [mapElem as! Map]
            } else {
                return self.walkMaps(mapElem.subElements)
            }
        })
    }
}