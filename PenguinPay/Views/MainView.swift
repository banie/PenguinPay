//
//  ContentView.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-30.
//

import SwiftUI
import Combine

struct MainView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedCountry = SupportedCountries().defaultSelected
    
    @FocusState private var isFirstNameFocused: Bool
    @FocusState private var isLastNameFocused: Bool
    @FocusState private var isPhoneNumberFocused: Bool
    
    @ObservedObject var presenter = MainViewPresenter(selectedCountry: SupportedCountries().defaultSelected)
    
    var body: some View {
        let supportedCountries = SupportedCountries()
        
        NavigationView {
            VStack(alignment: .leading, spacing: 20.0) {
                HStack {
                    Text("Send money to")
                        .font(.headline)
                    Spacer()
                    Picker("", selection: $selectedCountry) {
                        ForEach(supportedCountries.available, id: \.id) { country in
                            HStack(spacing: 20) {
                                Image(country.flagIconName)
                                Text(country.displayName)
                                    .font(.headline)
                            }.tag(country)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedCountry) { country in
                        presenter.selectedCountry = country
                    }
                    .disabled(presenter.sendStatus == .sending)
                }
                HStack {
                    Text("Recipient")
                        .font(.subheadline)
                    Spacer()
                    Text(presenter.rateTextToDisplay)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                HStack {
                    VStack {
                        Text("First name")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("", text: $firstName)
                            .keyboardType(.namePhonePad)
                            .frame(maxWidth: .infinity)
                            .disabled(presenter.sendStatus == .sending)
                            .focused($isFirstNameFocused)
                            .minimumScaleFactor(0.4)
                    }
                    .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.secondary, lineWidth: 1)
                        )

                    VStack {
                        Text("Last name")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("", text: $lastName)
                            .keyboardType(.namePhonePad)
                            .frame(maxWidth: .infinity)
                            .disabled(presenter.sendStatus == .sending)
                            .focused($isLastNameFocused)
                            .minimumScaleFactor(0.4)
                    }
                    .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.secondary, lineWidth: 1)
                        )
                }
                VStack {
                    Text("Phone number")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text(presenter.selectedCallRule?.dialPrefix ?? "")
                            .font(.callout)
                        TextField("", text: $phoneNumber)
                            .keyboardType(.asciiCapableNumberPad)
                            .frame(maxWidth: .infinity)
                            .disabled(presenter.sendStatus == .sending)
                            .focused($isPhoneNumberFocused)
                    }
                }
                .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.secondary, lineWidth: 1)
                    )
                    .alert("Please enter a correct phone number", isPresented: $presenter.showAlertBadPhoneNumber) {
                            Button("OK", role: .cancel) {
                                presenter.showAlertBadPhoneNumber = false
                            }
                        }
                
                VStack {
                    Text(String(format: "They will receive in %@", selectedCountry.currencyCode))
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("", text: $presenter.moneyForRecepient)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .disabled(true)
                        .minimumScaleFactor(0.4)
                }
                .padding()
                .alert("Your money has been sent", isPresented: $presenter.showAlertDone) {
                            Button("OK", role: .cancel) {
                                presenter.showAlertDone = false
                                firstName = ""
                                lastName = ""
                                phoneNumber = ""
                            }
                        }

                VStack {
                    HStack {
                        Text("You send")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if presenter.moneyToBeSent.isEmpty == false {
                            Button(action: {
                                presenter.clearMoney()
                            }, label: {
                                Image(systemName: "clear")
                                    .foregroundColor(.primary)
                            })
                        }
                    }
                    TextField("", text: $presenter.moneyToBeSent)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .disabled(true)
                        .minimumScaleFactor(0.4)
                }
                .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.secondary, lineWidth: 1)
                    )
                HStack {
                    Button(action: {
                        presenter.addOne()
                    }, label: {
                        Text("1")
                            .frame(maxWidth: .infinity)
                            .font(.largeTitle)
                            .padding()
                            .foregroundColor(.primary)
                            .background(.yellow)
                            .cornerRadius(16)
                    })
                    .disabled(presenter.sendStatus == .sending)
                    
                    Button(action: {
                        presenter.addZero()
                    }, label: {
                        Text("0")
                            .frame(maxWidth: .infinity)
                            .font(.largeTitle)
                            .padding()
                            .foregroundColor(.primary)
                            .background(.yellow)
                            .cornerRadius(16)
                    })
                    .disabled(presenter.sendStatus == .sending)
                }
                
                Button(action: {
                    presenter.sendMoneyTo(firstName: firstName, lastName: lastName, nsn: phoneNumber)
                }, label: {
                    Text("Send")
                        .frame(maxWidth: .infinity)
                        .font(.title)
                        .padding()
                        .foregroundColor(.primary)
                        .background(.yellow)
                        .cornerRadius(20)
                })
                .opacity(presenter.moneyToBeSent.isEmpty ? 0.5 : 1.0)
                .disabled(presenter.moneyToBeSent.isEmpty || presenter.sendStatus == .sending)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .onTapGesture {
                isFirstNameFocused = false
                isLastNameFocused = false
                isPhoneNumberFocused = false
            }
            .opacity(presenter.sendStatus == .sending ? 0.5 : 1.0)
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) { // <3>
                    HStack {
                        Image("penguin").foregroundColor(.yellow)
                        Text("PenguinPay")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                    }
                }
            }
        }.onAppear() {
            Task { await presenter.loadCurrencyRates() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
