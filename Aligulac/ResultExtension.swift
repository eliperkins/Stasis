//
//  ResultExtension.swift
//  Aligulac
//
//  Created by Eli Perkins (Venmo) on 12/1/14.
//  Copyright (c) 2014 eliperkins. All rights reserved.
//

import Foundation
import LlamaKit

func try<T>(f: NSErrorPointer -> T?, file: String = __FILE__, line: Int = __LINE__) -> Result<T> {
    var error: NSError?
    return f(&error).map(success) ?? failure(error ?? defaultError(file: file, line: line))
}

func try(f: NSErrorPointer -> Bool, file: String = __FILE__, line: Int = __LINE__) -> Result<()> {
    var error: NSError?
    return f(&error) ? success(()) : failure(error ?? defaultError(file: file, line: line))
}

private func defaultError(userInfo: [NSObject: AnyObject]) -> NSError {
    return NSError(domain: "", code: 0, userInfo: userInfo)
}

private func defaultError(message: String, file: String = __FILE__, line: Int = __LINE__) -> NSError {
    return defaultError([NSLocalizedDescriptionKey: message, ErrorFileKey: file, ErrorLineKey: line])
}

private func defaultError(file: String = __FILE__, line: Int = __LINE__) -> NSError {
    return defaultError([ErrorFileKey: file, ErrorLineKey: line])
}

