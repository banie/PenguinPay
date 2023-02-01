//
//  ContentView.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-30.
//

import SwiftUI

struct MainView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedCountry = SupportedCountries().defaultSelected
    
    @ObservedObject var presenter = MainViewPresenter(selectedCountry: SupportedCountries().defaultSelected)
    
    var body: some View {
        let supportedCountries = SupportedCountries()
        presenter.moneyForRecepient
        
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
                }
                Text("Recipient")
                    .font(.subheadline)
                HStack {
                    VStack {
                        Text("First name")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("", text: $firstName)
                            .keyboardType(.namePhonePad)
                            .frame(maxWidth: .infinity)
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
                    TextField("", text: $phoneNumber)
                        .keyboardType(.asciiCapableNumberPad)
                        .frame(maxWidth: .infinity)
                }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.secondary, lineWidth: 1)
                    )
                
                VStack {
                    Text(String(format: "They will receive in %@", selectedCountry.currencyCode))
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("", text: $presenter.moneyForRecepient)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .disabled(true)
                }
                .padding()

                VStack {
                    Text("You send")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("", text: $presenter.moneyToBeSent)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .disabled(true)
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
                }
                
                Button(action: {
                    print("Send")
                }, label: {
                    Text("Send")
                        .frame(maxWidth: .infinity)
                        .font(.title)
                        .padding()
                        .foregroundColor(.primary)
                        .background(.yellow)
                        .cornerRadius(20)
                })
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
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
