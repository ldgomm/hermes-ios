//
//  GetStoreByIdUseCase.swift
//  Hermes
//
//  Created by José Ruiz on 2/8/24.
//

import Combine
import Foundation

class GetStoreByIdUseCase {
    @Inject var serviceable: Serviceable
    
    /**
     This function invokes the post data operation with the provided ProductDto to the specified URL using the injected service.
     - Parameters:
       - url: The URL to which to send data.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func invoke(from url: URL) -> AnyPublisher<Result<StoreDto, NetworkError>, Never> {
        return serviceable.getDataById(from: url)
    }
}
