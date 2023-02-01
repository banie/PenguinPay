//
//  Country.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-31.
//

import Foundation

struct Country: Hashable, Equatable {
    let currencyCode: String
    var displayName: String
    var flagIconName: String
}

extension Country: Identifiable {
    var id: String {
        return currencyCode
    }
}
