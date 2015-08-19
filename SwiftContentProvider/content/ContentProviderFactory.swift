//
//  ContentProviderFactory.swift
//  SwiftContentProvider
//
//  Created by Jeff Roberts on 8/19/15.
//  Copyright © 2015 nimbleNoggin.io. All rights reserved.
//

import Foundation
import SwiftProtocolsCore

@objc
public class ContentProviderFactory : NSObject, TypedFactory {
    public func create(type: NSObject.Type) throws -> ContentProvider {
        throw CoreError.SubclassShouldImplementError
    }
}