//
//  Service.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Combine
import Foundation

final class Service: Serviceable {
    
    /**
     This function performs a GET request to retrieve data from the specified URL.
     - Parameters:
     - url: The URL from which to retrieve data.
     - Returns: A publisher emitting a Result type with the retrieved data or a NetworkError.
     */
    func getData<T: Decodable>(from url: URL) -> AnyPublisher<Result<T, NetworkError>, Never> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainHelper.shared.read(forKey: "jwt") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badRequestError
                }
                
                switch httpResponse.statusCode {
                case 200:
                    return data
                case 401:
                    throw NetworkError.unauthorizedError
                case 403:
                    throw NetworkError.forbiddenError
                case 404:
                    throw NetworkError.notFoundError
                case 304:
                    throw NetworkError.notModifiedError
                case 500...599:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.badRequestError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map(Result.success)
            .catch { error -> Just<Result<T, NetworkError>> in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    return Just(.failure(.decodeError(underlying: decodingError)))
                } else if let urlError = error as? URLError {
                    print("Download error: \(urlError)")
                    return Just(.failure(.downloadError(underlying: urlError)))
                } else {
                    print("Unknown error: \(error)")
                    return Just(.failure(.unknownError))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /**
     This function performs a GET request to retrieve data from the specified URL, expecting a redirection (status code 302).
     - Parameters:
     - url: The URL from which to retrieve data.
     - Returns: A publisher emitting a Result type with the retrieved data or a NetworkError.
     */
    func getDataById<T: Decodable>(from url: URL) -> AnyPublisher<Result<T, NetworkError>, Never> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainHelper.shared.read(forKey: "jwt") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badRequestError
                }
                
                switch httpResponse.statusCode {
                case 200:
                    return data
                case 401:
                    throw NetworkError.unauthorizedError
                case 403:
                    throw NetworkError.forbiddenError
                case 404:
                    throw NetworkError.notFoundError
                case 500...599:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.badRequestError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map(Result.success)
            .catch { error -> Just<Result<T, NetworkError>> in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    return Just(.failure(.decodeError(underlying: decodingError)))
                } else if let urlError = error as? URLError {
                    print("Download error: \(urlError)")
                    return Just(.failure(.downloadError(underlying: urlError)))
                } else {
                    print("Unknown error: \(error)")
                    return Just(.failure(.unknownError))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func getDataByKeywords<T>(from url: URL) -> AnyPublisher<Result<T, NetworkError>, Never> where T: Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainHelper.shared.read(forKey: "jwt") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badRequestError
                }
                
                switch httpResponse.statusCode {
                case 200:
                    return data
                case 401:
                    throw NetworkError.unauthorizedError
                case 403:
                    throw NetworkError.forbiddenError
                case 404:
                    throw NetworkError.notFoundError
                case 500...599:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.badRequestError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map(Result.success)
            .catch { error -> Just<Result<T, NetworkError>> in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    return Just(.failure(.decodeError(underlying: decodingError)))
                } else if let urlError = error as? URLError {
                    print("URL error: \(urlError)")
                    return Just(.failure(.downloadError(underlying: urlError)))
                } else {
                    print("Unexpected error: \(error)")
                    return Just(.failure(.unknownError))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    /**
     This function performs a POST request to send data to the specified URL.
     - Parameters:
     - url: The URL to which to send the data.
     - data: The data to send, encoded as U.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func postData<T, U>(from url: URL, with data: U) -> AnyPublisher<Result<T, NetworkError>, Never> where T : Decodable, U : Encodable {
        var request: URLRequest = .init(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(data)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainHelper.shared.read(forKey: "jwt") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.badRequestError
                }
                
                switch response.statusCode {
                case 200, 201:
                    // Expect JSON data here for successful requests.
                    print("Status code: \(response.statusCode)")
                    // Attempt to decode the response to T (your StoreDto or another Decodable object).
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        print("Decoded response: \(decodedResponse)")
                        return data
                    } catch let decodingError {
                        print("Failed to decode response: \(decodingError)")
                        throw NetworkError.decodeError(underlying: decodingError)
                    }
                    
                default:
                    print("Error status code: \(response.statusCode)")
                    throw NetworkError.badRequestError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map(Result.success)
            .catch { error -> Just<Result<T, NetworkError>> in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    return Just(.failure(.decodeError(underlying: decodingError)))
                } else {
                    print("Download error: \(error)")
                    return Just(.failure(.downloadError(underlying: error)))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        
    }
    
    /**
     This function performs a PUT request to update data at the specified URL.
     - Parameters:
     - url: The URL where the data is to be updated.
     - data: The data to be updated, encoded as U.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func putData<T: Decodable, U: Encodable>(from url: URL, with data: U) -> AnyPublisher<Result<T, NetworkError>, Never> {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(data)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainHelper.shared.read(forKey: "jwt") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badRequestError
                }
                
                // Handle different status codes explicitly
                switch httpResponse.statusCode {
                case 202:
                    return data
                case 401:
                    throw NetworkError.unauthorizedError
                case 403:
                    throw NetworkError.forbiddenError
                case 404:
                    throw NetworkError.notFoundError
                case 500...599:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.notModifiedError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map(Result.success)
            .catch { error -> Just<Result<T, NetworkError>> in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    return Just(.failure(.decodeError(underlying: decodingError)))
                } else if let urlError = error as? URLError {
                    print("URL error: \(urlError)")
                    return Just(.failure(.downloadError(underlying: urlError)))
                } else {
                    print("Unexpected error: \(error)")
                    return Just(.failure(.unknownError))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    /**
     This function performs a PATCH request to update data at the specified URL.
     - Parameters:
     - url: The URL where the data is to be updated.
     - data: The data to be updated, encoded as U.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func patchData<T: Decodable, U: Encodable>(from url: URL, with data: U) -> AnyPublisher<Result<T, NetworkError>, Never> {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONEncoder().encode(data)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainHelper.shared.read(forKey: "jwt") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badRequestError
                }
                
                // Handle status codes
                switch httpResponse.statusCode {
                case 202:
                    // 202 Accepted: Request was successful and is being processed
                    return data
                case 401:
                    throw NetworkError.unauthorizedError
                case 403:
                    throw NetworkError.forbiddenError
                case 404:
                    throw NetworkError.notFoundError
                case 500...599:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.notModifiedError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map(Result.success)
            .catch { error -> Just<Result<T, NetworkError>> in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    return Just(.failure(.decodeError(underlying: decodingError)))
                } else if let urlError = error as? URLError {
                    print("URL error: \(urlError)")
                    return Just(.failure(.downloadError(underlying: urlError)))
                } else {
                    print("Unexpected error: \(error)")
                    return Just(.failure(.unknownError))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    /**
     This function performs a DELETE request to delete data at the specified URL.
     - Parameter url: The URL from which to delete data.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func deleteData<T: Decodable, U: Encodable>(from url: URL, with data: U) -> AnyPublisher<Result<T, NetworkError>, Never> {
        // Create a URLRequest for the DELETE request.
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = try? JSONEncoder().encode(data)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainHelper.shared.read(forKey: "jwt") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        // Perform the DELETE request using URLSession's dataTaskPublisher.
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badRequestError
                }
                
                // Handle status codes
                switch httpResponse.statusCode {
                case 200, 204:
                    // 200 OK or 204 No Content indicates successful deletion
                    return data
                case 401:
                    throw NetworkError.unauthorizedError
                case 403:
                    throw NetworkError.forbiddenError
                case 404:
                    throw NetworkError.notFoundError
                case 500...599:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.badRequestError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map(Result.success)
            .catch { error -> Just<Result<T, NetworkError>> in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    return Just(.failure(.decodeError(underlying: decodingError)))
                } else if let urlError = error as? URLError {
                    print("URL error: \(urlError)")
                    return Just(.failure(.downloadError(underlying: urlError)))
                } else {
                    print("Unexpected error: \(error)")
                    return Just(.failure(.unknownError))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
