//
//  NetworkManager.swift
//  CryptoPriceTracker
//
//  Created by Gourav Kumar on 26/07/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init(){}
    enum RequestType: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    struct NetworkRequest {
        var host : String 
        var path : String
        var scheme : String
        var acceptEncoding : String?
        var requestType : RequestType
        var params : [String:String]
        var contentType : String?
        var authorisation : String?
        var customHeaders : [String: String]?
        var body : Data?
        var timoutInterval : Int
        var pathComponents : [String]
        var requestHeaders: [String: String] {
                var headers: [String: String] = [:]
                
                if let contentType = contentType {
                    headers["Content-Type"] = contentType
                }
                
                if let acceptEncoding = acceptEncoding {
                    headers["Accept-Encoding"] = acceptEncoding
                }
                
                if let authorisation = authorisation {
                    headers["Authorization"] = authorisation
                }

                if let custom = customHeaders {
                    for (key, value) in custom {
                        headers[key] = value
                    }
                }
                return headers
            }
    }
    enum NetworkError : Error {
        case faultyURL
        case faultyBody
        case badResponse(code : Int)
    }
    
    private func createRequest(networkRequest : NetworkRequest) throws -> URLRequest {
        
        var components = URLComponents()
        components.scheme = networkRequest.scheme
        components.host = networkRequest.host
        components.path = networkRequest.path
        components.queryItems = networkRequest.params.map{ URLQueryItem(name: $0.key, value: $0.value)}
        
        guard let url = components.url else { throw NetworkError.faultyURL}
        
        let fullURL = networkRequest.pathComponents.reduce(url) { partialURL, component in
            partialURL.appendingPathComponent(component)
        }
//        fullURL    Foundation.URL    "https://api.target.com/mobile_case_study_deals/v1?"    
        var request = URLRequest(url: fullURL, timeoutInterval: TimeInterval(networkRequest.timoutInterval))
        
        request.httpMethod = networkRequest.requestType.rawValue
        if [.post, .put, .delete].contains(networkRequest.requestType),
           let body = networkRequest.body {
            request.httpBody = body
        }
        networkRequest.requestHeaders.forEach{
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return request
    
    }
    
    
    func makeAPIRequest(networkRequest : NetworkRequest) async throws -> (Data,URLResponse){
        
        let dataRequest = try createRequest(networkRequest: networkRequest)
        let session = URLSession.shared
        let (data,response) = try await session.data(for: dataRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badResponse(code: 0) // need to establish code for this
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse(code: httpResponse.statusCode)
        }
        
        return (data,response)
    }
    
}
