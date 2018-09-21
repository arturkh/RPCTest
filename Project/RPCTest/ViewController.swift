//
//  ViewController.swift
//  RPCTest
//
//  Created by Artur Khidirnabiev on 18/09/2018.
//  Copyright © 2018 Artur Khidirnabiev. All rights reserved.
//

import UIKit
import SwiftRPCEthereum

class ViewController: UIViewController {
    let batch = RPCBatchRequest(url: URL(string: "http://127.0.0.1:8545")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // собираем вызовы
        let call = RPCCall(method: "eth_getBalance", params: ["0x28a910a287005b9865af040fddbc694e168bf74b", "latest"])
        let call1 = RPCCall(method: "eth_getBalance", params: ["0x4d81cbd8d3c889d83c7477bd40c690b24f926d960", "latest"])
        let call2 = RPCCall(method: "eth_getBalance", params: ["0x4d81cbd8d3c889d83c7477bd40c690b24f926d96", "latest"])
        let call3 = RPCCall(method: "eth_gasPrice", params: [])
        
        batch.addCalls([call, call1, call2, call3])
        batch.execute { (result) in
            switch result {
            case .success(_):
                self.showValues()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showValues() {
        for call in batch.calls {
            switch call.value {
            case .success(let result)?:
                print(result)
            case .failure(let error)?:
                print(error)
            case .none:
                assertionFailure()
            }
        }
    }
}

