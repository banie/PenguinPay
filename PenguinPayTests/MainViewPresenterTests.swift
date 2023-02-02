//
//  MainViewPresenterTests.swift
//  PenguinPayTests
//
//  Created by Banie Setijoso on 2023-02-02.
//

import XCTest
@testable import PenguinPay

final class MainViewPresenterTests: XCTestCase {
    
    private var getApiMock: GetCurrencyRatesApiMock!
    private var presenter: MainViewPresenter!
    private let availableCountries = SupportedCountries().available

    override func setUpWithError() throws {
        getApiMock = GetCurrencyRatesApiMock()
        presenter = MainViewPresenter(selectedCountry: availableCountries[0], getCurrencyRatesApi: getApiMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        XCTAssertEqual(presenter.sendStatus, .idle)
        XCTAssertFalse(presenter.showAlertDone)
        XCTAssertFalse(presenter.showAlertBadPhoneNumber)
        XCTAssertEqual(presenter.moneyToBeSent, "")
        XCTAssertEqual(presenter.moneyForRecepient, "")
    }

    func testLoadCurrencyRates() async throws {
        presenter.moneyToBeSent = "10"
        let rate = 124.5
        getApiMock.currencyRates = CurrencyRates(timestamp: Date(), base: "USD", rates: ["KES" : rate])
        await presenter.loadCurrencyRates()
        
        XCTAssertEqual(presenter.moneyForRecepient, String(Int(Double(Int("10", radix: 2) ?? 0) * rate), radix: 2))
    }
    
    func testAddZero() async throws {
        let rate = 130.5
        getApiMock.currencyRates = CurrencyRates(timestamp: Date(), base: "USD", rates: ["KES" : rate])
        
        await presenter.loadCurrencyRates()
        
        presenter.moneyToBeSent = "10"
        
        await MainActor.run {
            presenter.addZero()
            XCTAssertEqual(presenter.moneyToBeSent, "100")
            XCTAssertEqual(presenter.moneyForRecepient, String(Int(Double(Int("100", radix: 2) ?? 0) * rate), radix: 2))
        }
    }
    
    func testAddOne() async throws {
        let rate = 140.5
        getApiMock.currencyRates = CurrencyRates(timestamp: Date(), base: "USD", rates: ["KES" : rate])
        
        await presenter.loadCurrencyRates()
        
        presenter.moneyToBeSent = "10"
        
        await MainActor.run {
            presenter.addOne()
            XCTAssertEqual(presenter.moneyToBeSent, "101")
            XCTAssertEqual(presenter.moneyForRecepient, String(Int(Double(Int("101", radix: 2) ?? 0) * rate), radix: 2))
        }
    }
    
    @MainActor
    func testSendMoney() throws {
        presenter.sendMoneyTo(firstName: "my first name", lastName: "my last name", nsn: "12345")
        XCTAssertTrue(presenter.showAlertBadPhoneNumber)
        XCTAssertEqual(presenter.sendStatus, .idle)
        
        let requestExpectation = expectation(description: "send money executed")
        presenter.sendMoneyTo(firstName: "my first name", lastName: "my last name", nsn: "12345678")
        XCTAssertEqual(presenter.sendStatus, .sending)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.presenter.showAlertDone)
            XCTAssertEqual(self.presenter.moneyToBeSent, "")
            XCTAssertEqual(self.presenter.moneyForRecepient, "")
            
            requestExpectation.fulfill()
        }
        
        wait(for: [requestExpectation], timeout: 2)
    }
    
    @MainActor
    func testClearMoney() throws {
        presenter.moneyToBeSent = "10"
        presenter.moneyForRecepient = "101"
        
        presenter.clearMoney()
        XCTAssertTrue(presenter.moneyToBeSent.isEmpty)
        XCTAssertTrue(presenter.moneyForRecepient.isEmpty)
    }

    @MainActor
    func testSendDisabled() throws {
        XCTAssertTrue(presenter.sendIsDisabled)
        
        presenter.moneyForRecepient = "11"
        presenter.moneyToBeSent = "10"
        
        XCTAssertFalse(presenter.sendIsDisabled)
        
        presenter.sendStatus = .sending
        
        XCTAssertTrue(presenter.sendIsDisabled)
    }
}
