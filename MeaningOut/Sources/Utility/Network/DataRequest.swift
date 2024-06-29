//
//  DataRequest.swift
//  MeaningOut
//
//  Created by gnksbm on 6/29/24.
//

import Foundation

protocol DataRequest: AnyObject {
    func didReceive(data: Data)
    func didReceive(error: Error)
}

final class AnyDataRequest<T: Decodable>: DataRequest {
    let task: URLSessionTask?
    
    private var onNextEvent: ((T) -> Void)?
    private var onErrorEvent: ((Error) -> Void)?
    private var onCompleteEvent: (() -> Void)?
    
    init(task: URLSessionTask?) {
        self.task = task
    }
    
    deinit {
        onCompleteEvent?()
    }
    
    func decode<Item: Decodable>(
        type: Item.Type
    ) -> AnyDataRequest<Item> {
        let request = AnyDataRequest<Item>(task: task)
        if let task {
            RequestStorage.replaceRequest(
                taskID: task.taskIdentifier,
                request: request
            )
        }
        return request
    }
    
    func receive(
        onNext: @escaping (T) -> Void,
        onError: @escaping (Error) -> Void = { _ in },
        onComplete: @escaping () -> Void = { }
    ) {
        task?.resume()
        onNextEvent = onNext
        onErrorEvent = onError
        onCompleteEvent = onComplete
    }
    
    func didReceive(data: Data) {
        if let data = data as? T {
            onNextEvent?(data)
        } else {
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                self.onNextEvent?(result)
            } catch {
                didReceive(error: error)
            }
        }
    }
    
    func didReceive(error: Error) {
        onErrorEvent?(error)
    }
    
    @discardableResult
    func logRetainCount(
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) -> Self {
        return self
    }
}
