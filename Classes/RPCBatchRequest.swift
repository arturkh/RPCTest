//
//  RPCBatchCall.swift
//  RPCTest
//
//  Created by Artur Khidirnabiev on 20/09/2018.
//  Copyright © 2018 Artur Khidirnabiev. All rights reserved.
//

import Foundation
import Result

open class RPCRequest {
    public enum Error: Swift.Error {
        case cantSerialize(Data?, Swift.Error)
        case requestError(Swift.Error)
        case networkError(NetworkService.Error)
    }
    
    public var calls: [RPCCall]
    public var networkService: NetworkService
    public var serializer: Serialization
    public var parser: RPCParser
    public var requestProvider: RPCRequestProvider
    
    public init(url: URL) {
        calls = []
        serializer = RPCSerialization()
        networkService = NetworkService()
        parser = RPCParser()
        requestProvider = RPCRequestProvider(url: url, serializer: serializer)
    }
    
    open func execute(completion: @escaping ((Result<Void, Error>) -> Void)) {
        do {
            let request = try requestProvider.buildRequest(calls: calls)
            networkService.execute(request: request) { [weak self] (result) in
                guard let controller = self else { return }
                
                switch result {
                case .success(let data):
                    completion(Result(attempt: {
                        do {
                            if let decodedData = try controller.serializer.decode(data) {
                                controller.parser.parse(decodedData, forCalls: controller.calls)
                            }
                        } catch let error {
                            throw Error.cantSerialize(data, error)
                        }
                    }))
                case .failure(let error):
                    completion(.failure(.networkError(error)))
                }
            }
        } catch let error {
            completion(Result(error: .requestError(error)))
        }
    }
}

open class RPCBatchRequest: RPCRequest {
    open func addCalls(_ calls: [RPCCall]) {
        self.calls += calls
    }
}

open class RPCSignleRequest: RPCRequest  {
    public func setCall(_ call: RPCCall) {
        self.calls = [call]
    }
}
