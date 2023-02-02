//
//  MainViewPresenter.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-30.
//

import Foundation
import SwiftUI
import Combine

class MainViewPresenter: ObservableObject {
    enum SendStatus {
        case sending
        case idle
        case failed
    }
    
    @Published var sendStatus: SendStatus
    @Published var showAlertDone: Bool
    @Published var showAlertBadPhoneNumber: Bool
    @Published var moneyToBeSent: String
    @Published var moneyForRecepient: String
    
    var selectedCountry: Country {
        didSet {
            updateRecepientMoney()
        }
    }
    
    var selectedCallRule: CallRule? {
        CallRules().rules[selectedCountry.currencyCode]
    }
    
    private var currencyRates: CurrencyRates?
    
    init(selectedCountry: Country) {
        self.selectedCountry = selectedCountry
        sendStatus = .idle
        showAlertDone = false
        showAlertBadPhoneNumber = false
        moneyToBeSent = ""
        moneyForRecepient = ""
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
    
    func sendMoneyTo(firstName: String, lastName: String, nsn: String) {
        guard selectedCallRule?.nsnLengths.contains(nsn.count) ?? false else {
            showAlertBadPhoneNumber = true
            return
        }
        
        sendStatus = .sending
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showAlertDone = true
            self?.sendStatus = .idle
            self?.moneyForRecepient = ""
            self?.moneyToBeSent = ""
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
