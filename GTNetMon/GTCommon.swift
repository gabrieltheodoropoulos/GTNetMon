//
//  GTCommon.swift
//  GTRest
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Gabriel Theodoropoulos. All rights reserved.
//

import Foundation

/**
 It provides common String-related operations to Enums.
 
 List of provided operations:
 
 * `casesCollection()`: Get all Enum cases as a collection of String items.
 * `toString()`: Get a String representation of the current value
 
 - Precondition:
 Any Enum that adopts this protocol must also adopt `CaseIterable`.
 */
public protocol GTStringRepresentable {
    func casesCollection() -> [String]
    func toString() -> String
}


extension GTStringRepresentable where Self: CaseIterable {
    /**
     It returns an array with cases as String values.
     */
    public func casesCollection() -> [String] {
        return Self.allCases.map { "\($0)" }
    }
    
    
    /**
     A String representation of the current case.
     */
    public func toString() -> String {
        return casesCollection().filter { $0 == "\(self)" }[0]
    }
}
