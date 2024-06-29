//
//  NetworkService.swift
//  MeaningOut
//
//  Created by gnksbm on 6/27/24.
//

import Foundation

final class NetworkService: NSObject {
    static let shared = NetworkService()
    
    static let session = URLSession(
        configuration: .default,
        delegate: shared,
        delegateQueue: nil
    )
    
    private override init() { }
    
    func request(
        endpoint: EndpointRepresentable
    ) -> AnyDataRequest<Data> {
        do {
            let urlRequest = try endpoint.asURLRequest()
            let task = Self.session.dataTask(with: urlRequest)
            return RequestStorage.makeRequest(task: task)
        } catch {
            let request = AnyDataRequest<Data>(task: nil)
            request.didReceive(error: error)
            return request
        }
    }
}

extension NetworkService: URLSessionDataDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceiveInformationalResponse response: HTTPURLResponse
    ) {
        let request = RequestStorage.getRequest(taskID: task.taskIdentifier)
        guard 200..<300 ~= response.statusCode else {
            request?.didReceive(error: NetworkError.invalidResponseType)
            return
        }
    }
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        RequestStorage.getRequest(taskID: dataTask.taskIdentifier)?
            .didReceive(data: data)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: (any Error)?
    ) {
        if let error {            
            RequestStorage.getRequest(taskID: task.taskIdentifier)?
                .didReceive(error: NetworkError.requestFailed(error))
        } else {
            RequestStorage.removeRequest(taskID: task.taskIdentifier)
        }
    }
}
