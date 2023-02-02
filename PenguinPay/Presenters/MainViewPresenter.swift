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
    @Published var showAlertFailedFetchingRates: Bool
    @Published var moneyToBeSent: String
    @Published var moneyForRecepient: String
    
    @MainActor
    var selectedCountry: Country {
        didSet {
            updateRateToDisplay()
            updateRecepientMoney()
        }
    }
    
    @MainActor
    var selectedCallRule: CallRule? {
        CallRules().rules[selectedCountry.currencyCode]
    }
    
    @MainActor
    var sendIsDisabled: Bool {
        moneyForRecepient.isEmpty || moneyToBeSent.isEmpty || sendStatus == .sending
    }
    
    private(set) var rateTextToDisplay: String
    private(set) var currencyRates: CurrencyRates?
    
    private let getCurrencyRatesApi: GetCurrencyRatesApi
    
    init(selectedCountry: Country, getCurrencyRatesApi: GetCurrencyRatesApi = GetCurrencyRatesInteractor()) {
        self.selectedCountry = selectedCountry
        self.getCurrencyRatesApi = getCurrencyRatesApi
        sendStatus = .idle
        showAlertDone = false
        showAlertBadPhoneNumber = false
        showAlertFailedFetchingRates = false
        moneyToBeSent = ""
        moneyForRecepient = ""
        rateTextToDisplay = ""
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
            await MainActor.run {
                showAlertFailedFetchingRates = true
            }
        }
        
        await MainActor.run {
            updateRateToDisplay()
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
            self?.clearMoney()
        }
    }
    
    @MainActor
    func clearMoney() {
        moneyForRecepient = ""
        moneyToBeSent = ""
    }
    
    @MainActor
    private func updateRateToDisplay() {
        guard let rate = currencyRates?.rates[selectedCountry.currencyCode],
            let date = currencyRates?.timestamp else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM''d - h:mm a"
        let dateToDisplay = dateFormatter.string(from: date)
        rateTextToDisplay = String(format: "As of %@, 1 Dollar Binaria is equal to %@ %@", dateToDisplay, convert(binary: "1", rate: rate), selectedCountry.currencyCode)
    }
    
    @MainActor
    private func updateRecepientMoney() {
        guard let rate = currencyRates?.rates[selectedCountry.currencyCode] else {
            moneyForRecepient = ""
            return
        }
        
        moneyForRecepient = convert(binary: moneyToBeSent, rate: rate)
    }
    
    private func convert(binary: String, rate: Double) -> String {
        String(Int(Double(Int(binary, radix: 2) ?? 0) * rate), radix: 2)
    }
}
