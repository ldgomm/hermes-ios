//
//  encodeToJSON.swift
//  Hermes
//
//  Created by José Ruiz on 11/7/24.
//

import Foundation

/**
 Encodes a generic object into a JSON string.
 - Parameter object: The object to be encoded, which must conform to the `Encodable` protocol.
 - Returns: A JSON string representation of the object, or `nil` if encoding fails.
 - Note: This function uses `JSONEncoder` to encode the object. If encoding fails, it prints an error message to the console and returns `nil`.
 */
func encodeToJSON<T: Encodable>(_ object: T) -> String? {
    // Create a JSONEncoder instance
    let encoder = JSONEncoder()
    
    do {
        // Try to encode the object into JSON data
        let jsonData = try encoder.encode(object)
        
        // Convert the JSON data to a String
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    } catch {
        // Print an error message if encoding fails
        print("Error encoding JSON: \(error)")
    }
    
    // Return nil if encoding fails or if jsonString could not be created
    return nil
}
