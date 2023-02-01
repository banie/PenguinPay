//
//  GetCountryRatesInteractor.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-31.
//

import Foundation

class GetCountryRatesInteractor: GetInteractor, GetCountryRatesApi {
    
    init() {
        super.init(path: "latest.json")
    }
    
    func getCurrencyRates() async throws -> CurrencyRates {
        let currencyRates: CurrencyRates = try await get()
        return currencyRates
    }
}
