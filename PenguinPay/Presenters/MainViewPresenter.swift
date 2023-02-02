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
    
    @MainActor
    var selectedCountry: Country {
        didSet {
            updateRecepientMoney()
        }
    }
    
    @MainActor
    var selectedCallRule: CallRule? {
        CallRules().rules[selectedCountry.currencyCode]
    }
    
    private var currencyRates: CurrencyRates?
    private let getCurrencyRatesApi: GetCurrencyRatesApi
    
    init(selectedCountry: Country, getCurrencyRatesApi: GetCurrencyRatesApi = GetCurrencyRatesInteractor()) {
        self.selectedCountry = selectedCountry
        self.getCurrencyRatesApi = getCurrencyRatesApi
        sendStatus = .idle
        showAlertDone = false
        showAlertBadPhoneNumber = false
        moneyToBeSent = ""
        moneyForRecepient = ""
    }
    
    @MainActor
    func addZero() {
        moneyToBeSent += "0"
        updateRecepientMoney()
    }
    
    @MainActor
    func addOne() {
        moneyToBeSent += "1"
        updateRecepientMoney()
    }
    
    func loadCurrencyRates() async {
        do {
            currencyRates = try await getCurrencyRatesApi.getCurrencyRates()
        } catch {
            print("Failed in fetching currency rates, error: \(error)")
        }
        
        await MainActor.run {
            updateRecepientMoney()
        }
    }
    
    @MainActor
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
    
    @MainActor
    private func updateRecepientMoney() {
        guard let currencyRates = currencyRates,
            let rate = currencyRates.rates[selectedCountry.currencyCode] else {
            moneyForRecepient = moneyToBeSent
            return
        }
        
        moneyForRecepient = String(Int(Double(Int(moneyToBeSent, radix: 2) ?? 0) * rate), radix: 2)
    }
}
