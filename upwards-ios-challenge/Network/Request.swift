//
//  Request.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

struct HTTPMethod: RawRepresentable, ExpressibleByStringLiteral {
    let rawValue: String
    
    init?(rawValue: String) {
        self.init(stringLiteral: rawValue)
    }
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    static let get: HTTPMethod =  "GET"
    static let post: HTTPMethod =  "POST"
    static let put: HTTPMethod =  "PUT"
}

protocol Request: CustomStringConvertible {
    func asURLRequest() throws -> URLRequest
}
