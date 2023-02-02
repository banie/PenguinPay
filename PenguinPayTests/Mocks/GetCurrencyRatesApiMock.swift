//
//  GetCountryRatesApiMock.swift
//  PenguinPayTests
//
//  Created by Banie Setijoso on 2023-02-02.
//

import Foundation
@testable import PenguinPay

class GetCurrencyRatesApiMock: GetCurrencyRatesApi {
    var currencyRates: PenguinPay.CurrencyRates?
    func getCurrencyRates() async throws -> PenguinPay.CurrencyRates? {
        currencyRates
    }
}
