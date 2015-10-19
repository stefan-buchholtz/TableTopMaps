//
//  MapListElement.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 26.09.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import Foundation

protocol MapListElement {
    
    var name: String { get }
    
    var subElements: [MapListElement] { get }
    
    var isLeaf: Bool { get }
    
    var parent: MapFolder? { get set }
    
}


