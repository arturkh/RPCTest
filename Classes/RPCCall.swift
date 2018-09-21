//
//  RPCOperation.swift
//  RPCTest
//
//  Created by Artur Khidirnabiev on 18/09/2018.
//  Copyright © 2018 Artur Khidirnabiev. All rights reserved.
//

import Foundation
import Result

open class RPCCall {//: Codable {
    public enum RPCError: Swift.Error {
        case parseError(_ code: Int, _ message: String?)
        case invalidRequest(_ code: Int, _ message: String?)
        case methodNotFound(_ code: Int, _ message: String?)
        case invalidParams(_ code: Int, _ message: String?)
        case internalError(_ code: Int, _ message: String?)
        case serverError(_ code: Int, _ message: String?)
        case unknowError(_ code: Int, _ message: String?)
        
        static func getType(code: Int, message: String) -> RPCError {
            switch code {
            case -32700:
                return RPCError.parseError(code, message)
            case -32600:
                return RPCError.invalidRequest(code, message)
            case -32601:
                return RPCError.methodNotFound(code, message)
            case -32602:
                return RPCError.invalidParams(code, message)
            case -32603:
                return RPCError.internalError(code, message)
            case (-32000)...(-32099):
                return RPCError.serverError(code, message)
            default:
                return RPCError.unknowError(code, message)
            }
        }
    }
    
    public var id: Int
    public var method: String
    public var params: [Any]
    public var value: Result<Any, RPCError>?
    
    public init(method: String, params: [Any], id: Int? = nil) {
        if id == nil {
            self.id = Int.random(in: 1..<1000)
        } else {
            self.id = id!
        }
        self.method = method
        self.params = params
    }
}
