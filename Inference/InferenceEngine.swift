//
//  InferenceEngine.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//

import Foundation

public protocol InferenceEngine {
    associatedtype T: Value
    var variables: Variables<T> { get }
    var constraints: Constraints { get }
    var leadsToFailure: Bool { get }
    
    func makeNewInferences()
    func setNewInferences()
}
