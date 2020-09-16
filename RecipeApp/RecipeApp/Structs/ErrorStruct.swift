//
//  ErrorStruct.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 8/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import Foundation

struct CustomError: Error {
    let msg: String
    
    var localizedDescription: String {
        return NSLocalizedString(msg, comment: "")
    }
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
            return NSLocalizedString(msg, comment: "")
    }
}
