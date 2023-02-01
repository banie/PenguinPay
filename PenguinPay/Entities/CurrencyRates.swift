//
//  CurrencyRates.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-31.
//

import Foundation

struct CurrencyRates: Codable {
    let base: String
    let rates: [String: Double]
}
