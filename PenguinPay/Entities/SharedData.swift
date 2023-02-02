//
//  SupportedCountries.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-02-01.
//

import Foundation

struct SupportedCountries {
    let available = [Country(currencyCode: "KES", displayName: "Kenya", flagIconName: "kenya-flag"),
                     Country(currencyCode: "NGN", displayName: "Nigeria", flagIconName: "nigeria-flag"),
                     Country(currencyCode: "TZS", displayName: "Tanzania", flagIconName: "tanzania-flag"),
                     Country(currencyCode: "UGX", displayName: "Uganda", flagIconName: "uganda-flag")]
    
    var defaultSelected: Country {
        available[0]
    }
}

struct CallRules {
    let rules = ["KES": CallRule(dialPrefix: "+254", nsnLengths: [6, 7, 8, 9, 10]),
                 "NGN": CallRule(dialPrefix: "+234", nsnLengths: [7, 8, 9, 10]),
                 "TZS": CallRule(dialPrefix: "+255", nsnLengths: [9]),
                 "UGX": CallRule(dialPrefix: "+256", nsnLengths: [9])]
}
