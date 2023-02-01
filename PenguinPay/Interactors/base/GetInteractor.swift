//
//  GetInteractor.swift
//  PenguinPay
//
//  Created by Banie Setijoso on 2023-01-31.
//

import Foundation

class GetInteractor {
    
    let session: URLSession
    let decoder: JSONDecoder
    let baseUrl: String
    let path: String
    
    init(path: String) {
        baseUrl = Constants.API.openExchangeRateUrl
        session = URLSession.shared
        decoder = JSONDecoder()
        self.path = path
    }
    
    func get<T>() async throws -> T where T: Decodable {
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
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("status code: \(httpResponse.statusCode), request: \(request.curlString)")
        }
        
        return try decoder.decode(T.self, from: data)
    }
}
