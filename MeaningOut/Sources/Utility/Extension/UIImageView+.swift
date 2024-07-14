//
//  UIImageView+.swift
//  MeaningOut
//
//  Created by gnksbm on 7/14/24.
//

import UIKit

extension UIImageView {
    @discardableResult
    func setImageWithCahe(
        with url: URL,
        config: CacheConfiguration = .default
    ) -> URLSessionTask {
        @CacheWrapper<Data>(url: url, config: config)
        var savedObject
        var task: URLSessionTask
        switch savedObject {
        case .some(let cacheableData):
            let urlRequest = cacheableData.toURLRequest(url: url)
            task = URLSession.shared.dataTask(
                with: urlRequest
            ) { data, response, error in
                if let error {
                    Logger.error(NetworkError.requestFailed(error))
                    return
                }
                guard let response else {
                    Logger.error(NetworkError.noResponse)
                    return
                }
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    Logger.error(NetworkError.invalidResponseType)
                    return
                }
                guard httpURLResponse.statusCode != 304 else {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: cacheableData.value)
                    }
                    return
                }
                guard 200..<300 ~= httpURLResponse.statusCode else {
                    Logger.error(
                        NetworkError.statusCodeError(
                            statusCode: httpURLResponse.statusCode
                        )
                    )
                    return
                }
                guard let data else {
                    Logger.error(NetworkError.noData)
                    return
                }
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                if let newObject = CacheableObject(
                    value: data,
                    headers: httpURLResponse.allHeaderFields
                ) {
                    savedObject = newObject
                }
            }
        case .none:
            task = URLSession.shared.dataTask(
                with: url
            ) { data, response, error in
                if let error {
                    Logger.error(NetworkError.requestFailed(error))
                    return
                }
                guard let response else {
                    Logger.error(NetworkError.noResponse)
                    return
                }
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    Logger.error(NetworkError.invalidResponseType)
                    return
                }
                guard 200..<300 ~= httpURLResponse.statusCode else {
                    Logger.error(
                        NetworkError.statusCodeError(
                            statusCode: httpURLResponse.statusCode
                        )
                    )
                    return
                }
                guard let data else {
                    Logger.error(NetworkError.noData)
                    return
                }
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                if let newObject = CacheableObject(
                    value: data,
                    headers: httpURLResponse.allHeaderFields
                ) {
                    savedObject = newObject
                }
            }
        }
        task.resume()
        return task
    }
    
    private func handleTask() {
        
    }
}
