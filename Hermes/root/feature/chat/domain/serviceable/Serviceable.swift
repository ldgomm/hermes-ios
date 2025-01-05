//
//  Servicaable.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Combine
import Foundation

protocol Serviceable {
    
    /**
     This function performs a GET request to retrieve data from the specified URL.
     - Parameters:
       - url: The URL from which to retrieve data.
     - Returns: A publisher emitting a Result type with the retrieved data or a NetworkError.
     */
    func getData<T: Decodable>(from url: URL) -> AnyPublisher<Result<T, NetworkError>, Never>

    /**
     This function performs a GET request to retrieve data from the specified URL, expecting a redirection (status code 302).
     - Parameters:
       - url: The URL from which to retrieve data.
     - Returns: A publisher emitting a Result type with the retrieved data or a NetworkError.
     */
    func getDataById<T: Decodable>(from url: URL) -> AnyPublisher<Result<T, NetworkError>, Never>

    
    func getDataByKeywords<T: Decodable>(from url: URL) -> AnyPublisher<Result<T, NetworkError>, Never>

    /**
     This function performs a POST request to send data to the specified URL.
     - Parameters:
       - url: The URL to which to send data.
       - data: The data to be sent, conforming to the Encodable protocol.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func postData<T: Decodable, U: Encodable>(from url: URL, with data: U) -> AnyPublisher<Result<T, NetworkError>, Never>

    /**
     This function performs a PUT request to update data at the specified URL.
     - Parameters:
       - url: The URL at which to update data.
       - data: The data to be updated, conforming to the Encodable protocol.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func putData<T: Decodable, U: Encodable>(from url: URL, with data: U) -> AnyPublisher<Result<T, NetworkError>, Never>

    /**
     This function performs a PATCH request to update data at the specified URL.
     - Parameters:
       - url: The URL at which to update data.
       - data: The data to be updated, conforming to the Encodable protocol.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func patchData<T: Decodable, U: Encodable>(from url: URL, with data: U) -> AnyPublisher<Result<T, NetworkError>, Never>

    /**
     This function performs a DELETE request to delete data from the specified URL.
     - Parameter url: The URL from which to delete data.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func deleteData<T: Decodable, U: Encodable>(from url: URL, with data: U) -> AnyPublisher<Result<T, NetworkError>, Never>

}

enum NetworkError: Error {
    case decodeError(underlying: Error?)  // For decoding issues
    case downloadError(underlying: Error?) // For download failures or connection problems
    case notFoundError                    // For 404 errors
    case notModifiedError                 // For 304 errors
    case badRequestError                  // For 400 errors
    case unauthorizedError                // For 401 errors (authentication)
    case forbiddenError                   // For 403 errors (permissions)
    case serverError                      // For 500+ errors (server issues)
    case timeoutError                     // For request timeout
    case unknownError                     // Catch-all for unknown errors
    
    // Provide human-readable descriptions for each case.
    var localizedDescription: String {
        switch self {
        case .decodeError(let underlying):
            return "Decoding error occurred. \(underlying?.localizedDescription ?? "")"
        case .downloadError(let underlying):
            return "Failed to download data. \(underlying?.localizedDescription ?? "")"
        case .notFoundError:
            return "Resource not found (404)."
        case .notModifiedError:
            return "Resource not modified (304)."
        case .badRequestError:
            return "Bad request (400)."
        case .unauthorizedError:
            return "Unauthorized request (401)."
        case .forbiddenError:
            return "Access forbidden (403)."
        case .serverError:
            return "Server encountered an error (500+)."
        case .timeoutError:
            return "Request timed out."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
