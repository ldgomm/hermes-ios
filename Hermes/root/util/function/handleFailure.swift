//
//  handleFailure.swift
//  Hermes
//
//  Created by José Ruiz on 2/8/24.
//

import Foundation

/// Handles network failures by printing an appropriate error message based on the type of `NetworkError`.
///
/// - Parameter failure: The `NetworkError` to be handled. This determines which error message will be printed.
func handleNetworkError(_ failure: NetworkError) {
    // Switch on the specific type of NetworkError to print a corresponding error message
    switch failure {
    case .decodeError(let underlying):
        print("Decode error: \(failure.localizedDescription)")
        if let underlying = underlying {
            print("Underlying error: \(underlying)")
        }
        
    case .downloadError(let underlying):
        print("Download error: \(failure.localizedDescription)")
        if let underlying = underlying {
            print("Underlying error: \(underlying)")
        }
        
    case .notFoundError:
        print("Not found error: \(failure.localizedDescription)")
        
    case .notModifiedError:
        print("Not modified error: \(failure.localizedDescription)")
        
    case .badRequestError:
        print("Bad request error: \(failure.localizedDescription)")
        
    case .unauthorizedError:
        print("Unauthorized error: \(failure.localizedDescription)")
        // You might want to add actions like redirecting to login
        print("Please check your credentials and try again.")
        
    case .forbiddenError:
        print("Forbidden error: \(failure.localizedDescription)")
        // Additional actions like logging permission-related errors
        print("You do not have permission to perform this action.")
        
    case .serverError:
        print("Server error: \(failure.localizedDescription)")
        // Notify that the issue is on the server-side
        print("There was a problem on the server. Please try again later.")
        
    case .timeoutError:
        print("Timeout error: \(failure.localizedDescription)")
        // You might want to add retry logic for timeout errors
        print("The request timed out. Please check your connection and try again.")
        
    case .unknownError:
        print("Unknown error: \(failure.localizedDescription)")
        // Log additional information about the unknown error
        print("An unexpected error occurred. Please try again later.")
    }
}
