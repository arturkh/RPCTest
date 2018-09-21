//
//  RPCParser.swift
//  RPCTest
//
//  Created by Artur Khidirnabiev on 19/09/2018.
//  Copyright © 2018 Artur Khidirnabiev. All rights reserved.
//

import Foundation
import Result

open class RPCParser {
    @discardableResult
    open func parse(_ value: [[String: Any]], forCalls calls: [RPCCall]) -> [RPCCall] {
        for item in value {
            if let id: Int = item["id"] as? Int, let call: RPCCall = calls.first(where: {$0.id == id}) {
                parse(item, call: call)
            }
        }
        
        return calls
    }
    
    open func parse(_ dictionary: [String: Any], call: RPCCall) {
        if let result = dictionary["result"] {
            call.value = Result(value: result)
        } else if dictionary.contains(where: { (key, _) -> Bool in return (key == "error") ? true : false }) {
            if let error = dictionary["error"] as? [String: Any] {
                if let code = error["code"] as? Int, let message = error["message"] as? String {
                    call.value = Result(error: RPCCall.RPCError.getType(code: code, message: message))
                }
            }
        }
    }
}
