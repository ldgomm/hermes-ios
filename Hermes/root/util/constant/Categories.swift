//
//  Categories.swift
//  Sales
//
//  Created by José Ruiz on 3/4/24.
//

import Foundation

struct Mi: Hashable {
    let name: String
}

struct Ni: Hashable {
    let name: String
}

struct Xi {
    let name: String
}

typealias Categories = [Mi: [Ni: [Xi]]]

let categories: Categories = [
    Mi(name: "Mi1"): [
        Ni(name: "Ni1"): [
            Xi(name: "One"),
            Xi(name: "Two"),
            Xi(name: "Three")
        ],
        Ni(name: "Ni2"): [
            Xi(name: "Four"),
            Xi(name: "Five"),
            Xi(name: "Six")
        ]
    ],
    Mi(name: "Mi2"): [
        Ni(name: "Ni3"): [
            Xi(name: "Seven"),
            Xi(name: "Eight"),
            Xi(name: "Nine")
        ],
        Ni(name: "Ni4"): [
            Xi(name: "Ten"),
            Xi(name: "Eleven"),
            Xi(name: "Twelve")
        ]
    ]
]
