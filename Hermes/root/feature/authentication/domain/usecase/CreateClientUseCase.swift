//
//  CreateClientUseCase.swift
//  Hermes
//
//  Created by José Ruiz on 25/11/24.
//

import Combine
import Foundation

class CreateClientUseCase {
    @Inject var serviceable: Serviceable

    func invoke(from url: URL, for request: PostClientRequest) -> AnyPublisher<Result<LoginResponse, NetworkError>, Never> {
        return serviceable.postData(from: url, with: request)
    }
}
