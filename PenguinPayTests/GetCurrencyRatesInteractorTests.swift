//
//  GetCurrencyRatesInteractorTests.swift
//  PenguinPayTests
//
//  Created by Banie Setijoso on 2023-01-30.
//

import XCTest
@testable import PenguinPay

final class GetCurrencyRatesInteractorTests: XCTestCase {
    
    private var apiMock: NetworkRequestApiMock!
    private var interactor: GetCurrencyRatesInteractor!

    override func setUpWithError() throws {
        apiMock = NetworkRequestApiMock()
        interactor = GetCurrencyRatesInteractor(networkRequestApi: apiMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequest() async throws {
        let sampleResponse = """
            {
                "disclaimer": "Usage subject to terms: https://openexchangerates.org/terms",
                "license": "https://openexchangerates.org/license",
                "timestamp": 1675213200,
                "base": "USD",
                "rates": {
                    "AED": 3.672992,
                    "AFN": 88.944988,
                    "ALL": 107.618267,
                    "AMD": 396.009977,
                    "ANG": 1.802158,
                }
            }
        """.data(using: .utf8)!
        
        let requestExpectation = expectation(description: "request is made")
        apiMock.dataSpy = { request in
            let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
            let queryItems = components!.queryItems
            
            XCTAssertEqual(components?.host, "openexchangerates.org")
            XCTAssertEqual(components?.path, "/api/latest.json")
            XCTAssertEqual("application/json", request.value(forHTTPHeaderField: "Content-Type"))
            XCTAssertTrue(queryItems!.contains(URLQueryItem(name: "app_id", value: Constants.API.openExchangeRateAppId)))
            
            requestExpectation.fulfill()
            return .success(sampleResponse)
        }
        
        let currencyRates = try await interactor.getCurrencyRates()
        XCTAssertEqual("USD", currencyRates?.base)
        XCTAssertEqual(3.672992, currencyRates?.rates["AED"])
        
        wait(for: [requestExpectation], timeout: 1)
    }
}
