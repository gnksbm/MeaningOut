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
/**
 Endpoint에 대한 URL이나 URLRequest 생성을 명령 코드가 아닌 타입 선언 형식으로 구현하기 위한 프로토콜
 - 구성 요소를 타입으로 정의했기 때문에 컴파일 단계에서 부족한 요소를 쉽게 파악 가능
 - URLConvertible, URLRequestConvertible 프로토콜을 채택하여 Alamofire에서도 사용 가능
 */
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
