//
//  SearchClientProductsUseCase.swift
//  Hermes
//
//  Created by José Ruiz on 9/10/24.
//

import Combine
import Foundation

class SearchClientProductsUseCase {
    @Inject var serviceable: Serviceable

    func invoke(url: URL, request: ClientProductRequest) -> AnyPublisher<Result<ClientProductResponse, NetworkError>, Never> {
        return serviceable.postData(from: url, with: request)
    }
}
