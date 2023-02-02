//
//  NetworkRequestApiMock.swift
//  PenguinPayTests
//
//  Created by Banie Setijoso on 2023-02-02.
//

import Foundation
@testable import PenguinPay

class NetworkRequestApiMock: NetworkRequestApi {
    var dataSpy: ((_ request: URLRequest) async throws -> Result<Data, PenguinPay.NetworkApiError>)?
    var dataResult: Result<Data, NetworkApiError>?
    
    func data(for request: URLRequest) async throws -> Result<Data, PenguinPay.NetworkApiError> {
        try await dataSpy?(request) ?? dataResult ?? .failure(.urlIsInvalid)
    }
}
