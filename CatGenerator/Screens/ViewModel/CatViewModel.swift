//
//  CatViewModel.swift
//  CatGenerator
//
//  Created by WhyQ on 08/10/24.
//

import Foundation
import Combine

class CatViewModel {
    @Published var catImage: String?
    @Published var catFact: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let catService: CatServiceProtocol

    // Dependency Injection through initializer with a default value
    init(catService: CatServiceProtocol = APIManager()) {
        self.catService = catService
    }

    // Function to fetch both the cat image and fact
    func fetchRandomCatData() {
        isLoading = true
        errorMessage = nil

        guard let imageURL = URL(string: APIConstants.catImageURL),
              let factURL = URL(string: APIConstants.catFactURL) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        // Fetch image using the generic function
        let imagePublisher: AnyPublisher<[CatImage]?, Never> = catService.fetchData(from: imageURL, type: [CatImage].self)

        // Fetch fact using the generic function
        let factPublisher: AnyPublisher<CatFact?, Never> = catService.fetchData(from: factURL, type: CatFact.self)

        // Combine both publishers
        Publishers.Zip(imagePublisher, factPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (imageResponse, factResponse) in
                guard let self = self else { return }

                if let imageResponse = imageResponse, !imageResponse.isEmpty {
                    self.catImage = imageResponse.first?.url ?? "No Image"
                } else {
                    self.catImage = nil
                    self.errorMessage = "Failed to fetch cat image"
                }

                if let factResponse = factResponse {
                    self.catFact = factResponse.data.first ?? "No Fact"
                } else {
                    self.catFact = nil
                    self.errorMessage = self.errorMessage ?? "Failed to fetch cat fact"
                }

                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
