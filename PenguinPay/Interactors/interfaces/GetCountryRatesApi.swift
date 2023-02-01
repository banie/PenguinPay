//
//  GetCountryRatesApi.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-31.
//

import Foundation

protocol GetCountryRatesApi {
    func getCurrencyRates() async throws -> CurrencyRates
}
