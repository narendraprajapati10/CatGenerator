//
//  CatViewModelTests.swift
//  CatGeneratorTests
//
//  Created by WhyQ on 08/10/24.
//

import XCTest
import Combine
@testable import CatGenerator

class CatViewModelTests: XCTestCase {
    var viewModel: CatViewModel!
    var mockCatService: MockCatService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockCatService = MockCatService()
        viewModel = CatViewModel(catService: mockCatService)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockCatService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchRandomCatDataSuccess() {
        // Given
        mockCatService.shouldReturnError = false
        
        // When
        let expectation = XCTestExpectation(description: "Data fetched successfully")
        viewModel.$catImage
            .dropFirst() // Skip the initial value
            .sink { imageUrl in
                if imageUrl != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchRandomCatData()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertNotNil(viewModel.catImage)
        XCTAssertNotNil(viewModel.catFact)
    }

    func testFetchRandomCatDataFailure() {
        // Given
        mockCatService.shouldReturnError = true

        // When
        let expectation = XCTestExpectation(description: "Data fetching failed")
        viewModel.$errorMessage
            .dropFirst() // Skip the initial value
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchRandomCatData()

        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertNil(viewModel.catImage)
        XCTAssertNil(viewModel.catFact)
        XCTAssertEqual(viewModel.errorMessage, "Failed to fetch cat image")
    }
}
