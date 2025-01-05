//
//  decodeFromJSON.swift
//  Hermes
//
//  Created by José Ruiz on 11/7/24.
//

import Foundation

func decodeFromJSON<T: Decodable>(_ jsonString: String?) -> T? {
   // Ensure the JSON string is not nil and convert it to Data
   guard let jsonString = jsonString,
         let jsonData = jsonString.data(using: .utf8) else {
       return nil
   }
   
   // Create a JSONDecoder instance
   let decoder = JSONDecoder()
   
   do {
       // Try to decode the JSON data into the specified type
       let object = try decoder.decode(T.self, from: jsonData)
       return object
   } catch {
       // Print an error message if decoding fails
       print("Failed to decode JSON: \(error)")
       return nil
   }
}
