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
    
    var selectedCountry: Country {
        didSet {
            updateRecepientMoney()
        }
    }
    
    private var currencyRates: CurrencyRates?
    
    init(selectedCountry: Country) {
        self.moneyToBeSent = ""
        self.moneyForRecepient = ""
        self.selectedCountry = selectedCountry
    }
    
    func addZero() {
        moneyToBeSent += "0"
        updateRecepientMoney()
    }
    
    func addOne() {
        moneyToBeSent += "1"
        updateRecepientMoney()
    }
    
    func loadCurrencyRates() async {
        do {
            let getCurrencyRatesInteractor = GetCountryRatesInteractor()
            currencyRates = try await getCurrencyRatesInteractor.getCurrencyRates()
        } catch {
            print("Failed in fetching currency rates, error: \(error)")
        }
    }
    
    private func updateRecepientMoney() {
        guard let currencyRates = currencyRates,
            let rate = currencyRates.rates[selectedCountry.currencyCode] else {
            moneyForRecepient = moneyToBeSent
            return
        }
        
        moneyForRecepient = String(Int(Double(Int(moneyToBeSent, radix: 2) ?? 0) * rate), radix: 2)
    }
}
