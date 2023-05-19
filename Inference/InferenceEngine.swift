//
//  InferenceEngine.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//

import Foundation

public protocol InferenceEngine {
    var variables: [any Variable] { get }
    var constraints: Constraints { get }
    
    func makeNewInference() -> Inference
}
