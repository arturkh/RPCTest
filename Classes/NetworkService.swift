//
//  RPC.swift
//  RPCTest
//
//  Created by Artur Khidirnabiev on 18/09/2018.
//  Copyright © 2018 Artur Khidirnabiev. All rights reserved.
//

import Foundation
import Result

open class NetworkService {
    public enum Error: Swift.Error {
        case clientError(Data?, URLResponse?, Swift.Error?)
        case serverError(Data?, URLResponse?, Swift.Error?)
        case requestError(Data?, URLResponse?, Swift.Error?)
        case unknownError(Data?, URLResponse?, Swift.Error?)
    }
    
    public let session: URLSession
    
    public init() {
        session = URLSession(configuration: .default)
    }
    
    public init(withSessionConfiguration configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    open func execute(request: URLRequest, completion: @escaping ((_ result: Result<Data, Error>) -> Void)) {
        let task = session.dataTask(with: request) { (data, httpResponse, requestError) in
            if let requestError = requestError {
                completion(.failure(.requestError(data, httpResponse, requestError)))
            } else if let httpResponse = httpResponse as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 400..<500:
                    completion(Result(error: .clientError(data, httpResponse, requestError)))
                case 500..<600:
                    completion(Result(error: .serverError(data, httpResponse, requestError)))
                case 200:
                    if let data = data {
                        completion(Result(value: data))
                    } else {
                        completion(Result(error: .unknownError(data, httpResponse, requestError)))
                    }
                default:
                    completion(Result(error: .unknownError(data, httpResponse, requestError)))
                }
            }
        }
        task.resume()
    }
}
