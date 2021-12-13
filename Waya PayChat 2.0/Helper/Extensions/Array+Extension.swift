//
//  Array+Extension.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 02/06/2021.
//

import Foundation


extension Array {
    public mutating func appendDistinct<S>(contentsOf newElements: S, where condition:@escaping (Element, Element) -> Bool) where S : Sequence, Element == S.Element {
        newElements.forEach { (item) in
            if !(self.contains(where: { (selfItem) -> Bool in
                return !condition(selfItem, item)
            })) {
                self.append(item)
            }
        }
    }
    
    public mutating func replacing<T>(contentsOf newElements: T, where condition: @escaping (Element, Element) -> Bool) where T: Sequence, Element == T.Element {
        newElements.forEach { (item) in
            if let index = self.firstIndex(where: { (element) -> Bool in
                return condition(element, item)
            }) {
                self[index] = item
            } else {
                self.append(item)
            }
        }
    }
}
