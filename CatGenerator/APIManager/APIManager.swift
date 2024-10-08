//
//  CatService.swift
//  CatGenerator
//
//  Created by WhyQ on 08/10/24.
//

import Foundation
import Combine

// MARK: - Cat Service

// Define a protocol for the CatService
protocol CatServiceProtocol {
    func fetchData<T: Decodable>(from url: URL, type: T.Type) -> AnyPublisher<T?, Never>
}

// APIManager class conforms to CatServiceProtocol
class APIManager: CatServiceProtocol {
    
    // Generic function to fetch any type of data
    func fetchData<T: Decodable>(from url: URL, type: T.Type) -> AnyPublisher<T?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map { $0 }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

