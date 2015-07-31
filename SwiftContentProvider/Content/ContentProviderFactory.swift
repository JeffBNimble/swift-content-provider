//
//  ContentProviderFactory.swift
//  SwiftContentProvider
//
//  A component that creates ContentProvider instances.
//
//  Created by Jeff Roberts on 7/25/15.
//  Copyright © 2015 nimbleNoggin.io. All rights reserved.
//

import Foundation

public protocol ContentProviderFactory {
    /// createContentProvider: Create an instance of a Content Provider
    /// Parameter contentProviderType: The type to create
    /// Returns: An instance of type contentProviderType, which conforms to the ContentProvider protocol
    func createContentProvider(contentProviderType: NSObject.Type) -> ContentProvider
}