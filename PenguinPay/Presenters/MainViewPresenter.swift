//
//  MainViewPresenter.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-30.
//

import Foundation
import SwiftUI

class MainViewPresenter: ObservableObject {
    @Published var moneyToBeSent: String
    @Published var moneyForRecepient: String
    @Published var countries = [Country(currencyCode: "KES", displayName: "Kenya", flagIconName: "kenya-flag"),
                     Country(currencyCode: "NGN", displayName: "Nigeria", flagIconName: "nigeria-flag"),
                     Country(currencyCode: "TZS", displayName: "Tanzania", flagIconName: "tanzania-flag"),
                     Country(currencyCode: "UGX", displayName: "Uganda", flagIconName: "uganda-flag")]
    
    init() {
        self.moneyToBeSent = ""
        self.moneyForRecepient = ""
    }
    
    func addZero() {
        moneyToBeSent += "0"
        updateRecepientMoney()
    }
    
    func addOne() {
        moneyToBeSent += "1"
        updateRecepientMoney()
    }
    
    private func updateRecepientMoney() {
        moneyForRecepient = String(Int(Double(Int(moneyToBeSent, radix: 2) ?? 0) * 1.36), radix: 2)
    }
}
