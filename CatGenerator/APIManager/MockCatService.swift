//
//  MockCatService.swift
//  CatGenerator
//
//  Created by WhyQ on 08/10/24.
//

import Foundation
import Combine


// Mock class conforming to the CatServiceProtocol
class MockCatService: CatServiceProtocol {
    var shouldReturnError = false

    // Mock function to simulate image fetching
    func fetchData<T>(from url: URL, type: T.Type) -> AnyPublisher<T?, Never> where T : Decodable {
        if shouldReturnError {
            // Simulate error response by returning nil
            return Just(nil)
                .eraseToAnyPublisher()
        } else {
            // Provide mock responses based on the type
            if type == [CatImage].self {
                let mockImage = CatImage(url: "https://cdn2.thecatapi.com/images/1dm.png")
                return Just([mockImage] as? T)
                    .eraseToAnyPublisher()
            } else if type == CatFact.self {
                let mockFact = CatFact(data: ["Cats have individual preferences for scratching surfaces and angles."])
                return Just(mockFact as? T)
                    .eraseToAnyPublisher()
            } else {
                return Just(nil).eraseToAnyPublisher()
            }
        }
    }
}
