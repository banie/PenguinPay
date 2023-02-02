//
//  GetInteractor.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-31.
//

import Foundation

class GetInteractor {
    
    let networkRequestApi: NetworkRequestApi
    let decoder: JSONDecoder
    let baseUrl: String
    let path: String
    
    init(path: String, networkRequestApi: NetworkRequestApi) {
        baseUrl = Constants.API.openExchangeRateUrl
        decoder = JSONDecoder()
        self.path = path
        self.networkRequestApi = networkRequestApi
    }
    
    func get<T>() async throws -> T? where T: Decodable {
        guard let url = URL(string: path, relativeTo: URL(string: baseUrl)),
              var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkApiError.urlIsInvalid
        }
        
        let queryItemAppId = URLQueryItem(name: "app_id", value: Constants.API.openExchangeRateAppId)
        urlComponent.queryItems = [queryItemAppId]
        
        guard let composedUrl = urlComponent.url else {
            throw NetworkApiError.urlIsInvalid
        }
        
        var request = URLRequest(url: composedUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let result = try await networkRequestApi.data(for: request)
        
        switch result {
        case .success(let data):
            return try decoder.decode(T.self, from: data)
        case .failure(_):
            return nil
        }
    }
}
