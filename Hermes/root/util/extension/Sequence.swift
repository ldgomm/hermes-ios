//
//  Sequence.swift
//  Hermes
//
//  Created by José Ruiz on 4/7/24.
//

import Foundation

extension Sequence {
    
    func groupBy<U: Hashable>(key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var dict: [U: [Iterator.Element]] = [:]
        forEach { element in
            let key = key(element)
            if dict[key] == nil {
                dict[key] = [element]
            } else {
                dict[key]?.append(element)
            }
        }
        return dict
    }
    
    //    func groupBy<U: Hashable>(key: (Iterator.Element) -> U?) -> [U: [Iterator.Element]] {
    //        var dict: [U: [Iterator.Element]] = [:]
    //        forEach { element in
    //            if let key = key(element) {
    //                if dict[key] == nil {
    //                    dict[key] = [element]
    //                } else {
    //                    dict[key]?.append(element)
    //                }
    //            }
    //        }
    //        return dict
    //    }
}
