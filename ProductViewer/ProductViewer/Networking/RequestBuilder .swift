//
//  RequestBuilder .swift
//  CryptoPriceTracker
//
//  Created by Gourav Kumar on 26/07/25.
//

import Foundation

class NetworkRequestBuilder {
    private var host: String = ""
    private var path: String = ""
    private var requestType: NetworkManager.RequestType = .get
    private var params: [String: String] = [:]
    private var headers: [String: String] = [:]
    private var timeout: Int = 30 
    private var body: Data? = nil
    private var scheme : String = "https" // default scheme
    private var pathComponents : [String] = []
    
    func setHost(_ host: String) -> Self {
        self.host = host
        return self
    }
    
    func setScheme(_ scheme : String)-> Self {
        self.scheme = scheme
        return self
    }
    
    func setPath(_ path: String) -> Self {
        self.path = path
        return self
    }
    func appendPathComponent(_ component : String) -> Self {
        pathComponents.append(component)
        return self
    }
    
    func setMethod(_ method: NetworkManager.RequestType) -> Self {
        self.requestType = method
        return self
    }

    func setParams(_ params: [String: String]) -> Self {
        self.params = params
        return self
    }

    func addHeader(key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }

    func setTimeout(_ seconds: Int) -> Self {
        self.timeout = seconds
        return self
    }

    func setBody(_ data: Data?) -> Self {
        self.body = data
        return self
    }

    func build() -> NetworkManager.NetworkRequest {
        return NetworkManager.NetworkRequest(
            host: host,
            path: path,
            scheme: scheme,
            acceptEncoding: headers["Accept-Encoding"],
            requestType: requestType,
            params: params,
            contentType: headers["Content-Type"],
            authorisation: headers["Authorization"],
            customHeaders: headers,
            body: body,
            timoutInterval: timeout,
            pathComponents: pathComponents
        )
    }
}
