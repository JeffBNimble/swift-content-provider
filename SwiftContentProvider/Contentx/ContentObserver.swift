//
//  ContentObserver.swift
//  SwiftContentProvider
//
// A ContentObserver is an object that registers for and is notified of content updates
// using identifying Uri's. These Uri's are used by the ContentObserver to determine exactly
// what content has changed.
//
//
//  Created by Jeff Roberts on 7/25/15.
//  Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

import Foundation

@objc
public enum ContentOperation : Int {
    case Insert
    case Update
    case Delete
}

@objc
public protocol ContentObserver {
    /// onUpdate: Called on the conforming object when a content URI for which the object has registered to be notified has been updated
    /// Parameter contentUri: The identifying Uri referencing the piece of content that has changed
    /// Parameter operation: The type of operation that has occured (Insert, Update, Delete)
    func onUpdate(contentUri: NSURL, operation: ContentOperation)
}
