//
//  InferenceEngine.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//

import Foundation

public protocol InferenceEngine {
    associatedtype T: Value
    var variables: Set<Variable<T>> { get }
    var constraints: Constraints { get }
    
    func makeNewInference() -> Inference<T>
}
