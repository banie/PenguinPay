//
//  GetCurrencyRatesApi.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-31.
//

import Foundation

protocol GetCurrencyRatesApi {
    func getCurrencyRates() async throws -> CurrencyRates?
}
