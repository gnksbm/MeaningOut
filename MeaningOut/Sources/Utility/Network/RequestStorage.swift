//
//  RequestStorage.swift
//  MeaningOut
//
//  Created by gnksbm on 6/29/24.
//

import Foundation

enum RequestStorage {
    private static var storage = [Int: DataRequest]()
    
    static func makeRequest(task: URLSessionTask) -> AnyDataRequest<Data> {
        let request = AnyDataRequest<Data>(task: task)
        storage[task.taskIdentifier] = request
        return request
    }
    
    static func replaceRequest(taskID: Int, request: DataRequest) {
        storage[taskID] = request
    }
    
    static func getRequest(taskID: Int) -> DataRequest? {
        storage[taskID]
    }
    
    static func removeRequest(taskID: Int) {
        storage.removeValue(forKey: taskID)
    }
}
