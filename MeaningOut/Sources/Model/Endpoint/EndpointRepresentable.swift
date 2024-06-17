//
//  EndpointRepresentable.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import Foundation

import Alamofire

enum EndpointError: LocalizedError {
    case invalidURL
    case invalidURLRequest
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "유효하지 않은 URL"
        case .invalidURLRequest:
            "유효하지 않은 URLRequest"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum Scheme: String {
    case http, https, ws
}

protocol EndpointRepresentable: URLConvertible, URLRequestConvertible {
    var httpMethod: HTTPMethod { get }
    var scheme: Scheme { get }
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
    var queries: [String: String]? { get }
    var header: [String : String]? { get }
    var body: [String: any Encodable]? { get }
    
    func toURLRequest() -> URLRequest?
    func toURL() -> URL?
}

extension EndpointRepresentable {
    var port: Int? { nil }
    var queries: [String: String]? { nil }
    var header: [String : String]? { nil }
    var body: [String: any Encodable]? { nil }
    
    func toURLRequest() -> URLRequest? {
        guard let url = toURL() else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = httpMethod.rawValue
        if let body {
            let httpBody = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = httpBody
        }
        return request
    }
    
    func toURL() -> URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.port = port
        components.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return components.url
    }
}

// MARK: Alamofire
extension EndpointRepresentable {
    func asURL() throws -> URL {
        guard let url = toURL() else { throw EndpointError.invalidURLRequest }
        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let urlRequest = toURLRequest()
        else { throw EndpointError.invalidURLRequest }
        return urlRequest
    }
}
