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
