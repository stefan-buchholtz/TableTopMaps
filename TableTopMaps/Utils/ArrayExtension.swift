//
//  ArrayExtension.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 08.10.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import Foundation

extension Array {
    
    public mutating func appendCompatibleElementsOf<S: SequenceType>(elements: S) {
        for elem in elements {
            if let elem = elem as? Element {
                append(elem)
            }
        }
        
    }
    
}