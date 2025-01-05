//
//  DI.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation
import SwiftData

struct DependencyInjector {
    private static var dependencyList: [String: Any] = [:]
    
    static func inject<T>() -> T {
        guard let t = dependencyList[String(describing: T.self)] as? T else {
            fatalError("No provider registered for type: \(T.self)")
        }
        return t
    }
    
    static func singleton<T>(dependency: T) {
        dependencyList[String(describing: T.self)] = dependency
    }
}

@propertyWrapper struct Inject<T> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = DependencyInjector.inject()
        print("\(self.wrappedValue) injected")
    }
}

@propertyWrapper struct Singleton<T> {
    var wrappedValue: T
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        DependencyInjector.singleton(dependency: wrappedValue)
        print("\(self.wrappedValue) created")
    }
}
