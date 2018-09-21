//
//  RPCService2.swift
//  RPCTest
//
//  Created by Artur Khidirnabiev on 18/09/2018.
//  Copyright © 2018 Artur Khidirnabiev. All rights reserved.
//

import Foundation

public protocol Serialization {
    func encode(_ value: [[String: Any]]) throws -> Data
    func decode(_ value: Data) throws -> [[String: Any]]?
}

open class RPCSerialization: Serialization {
    open func encode(_ value: [[String: Any]]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: value)
    }
    
    open func decode(_ value: Data) throws -> [[String: Any]]? {
        return try JSONSerialization.jsonObject(with: value) as? [[String : Any]]
    }
}
