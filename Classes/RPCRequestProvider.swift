//
//  RequestProvider.swift
//  RPCTest
//
//  Created by Artur Khidirnabiev on 19/09/2018.
//  Copyright © 2018 Artur Khidirnabiev. All rights reserved.
//

import Foundation

open class RPCRequestProvider {
    var url: URL
    var serializer: Serialization
    
    public init(url: URL, serializer: Serialization) {
        self.url = url
        self.serializer = serializer
    }
    
    open func buildRequest(calls: [RPCCall]) throws -> URLRequest {
        var commands: [[String: Any]] = []
        for call in calls {
            commands.append(["jsonrpc": "2.0", "method": call.method, "id": call.id, "params": call.params])
        }

        let data = try serializer.encode(commands)
        
        let request = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        request.httpBody = data
        return request as URLRequest
    }
}
