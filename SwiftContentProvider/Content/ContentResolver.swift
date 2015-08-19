//
//  ContentResolver.swift
//  SwiftContentProvider
//
//  ContentResolver delegates requests to query or manipulate content to a registered ContentProvider for resolution.
//  It is the responsibility of the caller to call on an appropriate thread as the request is carried out on the calling thread.
//
//  Created by Jeff Roberts on 7/25/15.
//  Copyright © 2015 nimbleNoggin.io. All rights reserved.
//

import Foundation
import SwiftProtocolsCore
import SwiftProtocolsSQLite

public enum ContentProviderError : ErrorType {
    case NoRegisteredContentProvider
}

@objc
public class ContentResolver : NSObject {
    
    private var activeContentProviderRegistry : [String : ContentProvider]
    private let contentAuthorityBase : String
    private var contentObservers : [String : [ContentRegistration]]
    private let contentProviderFactory : ContentProviderFactory
    private var contentRegistrations : [String : NSObject.Type]
    
    public init(contentProviderFactory: ContentProviderFactory, contentAuthorityBase: String, contentRegistrations: [String : NSObject.Type] ) {
        self.contentProviderFactory = contentProviderFactory
        self.contentAuthorityBase = contentAuthorityBase
        self.contentRegistrations = contentRegistrations
        self.contentObservers = [:]
        self.activeContentProviderRegistry = [:]
        
        super.init()
        
        self.initialize()
    }
    
    public func delete(contentUri: Uri, selection: String?, selectionArgs: [String]?) throws -> Int {
        let contentProvider = try self.getContentProviderFor(contentUri)
        return try contentProvider!.delete(contentUri, selection: selection, selectionArgs: selectionArgs)
    }
    
    public func delete(contentUri: Uri, selection: String?, selectionArgs: [String : AnyObject]?) throws -> Int {
        let contentProvider = try self.getContentProviderFor(contentUri)
        return try contentProvider!.delete(contentUri, selection: selection, selectionArgs: selectionArgs)
    }
    
    public func insert(contentUri: Uri, values: [String : AnyObject]) throws -> Uri {
        let contentProvider = try self.getContentProviderFor(contentUri)
        return try contentProvider!.insert(contentUri, values: values)
    }
    
    public func notifyChange(contentUri: Uri, operation: ContentOperation) {
        let contentUriString = contentUri.absoluteString
        let registrations = self.contentObservers.flatMap() { (element) in
                return element.1 // Return the Array of registrations
            }
            .filter() { (registration) in
                registration.contentUri.isEqual(contentUri) ||
                    (registration.notifyForDescendents && contentUriString.hasPrefix(registration.contentUri.absoluteString))
            }
        
        for registration in registrations {
            registration.contentObserver.onUpdate(contentUri, operation: operation)
        }
    }
    
    public func query(contentUri: Uri, projection: [String]?, selection: String?, selectionArgs: [String]?, groupBy: String?, having: String?, sort: String?) throws -> Cursor {
        let contentProvider = try self.getContentProviderFor(contentUri)
        return try contentProvider!.query(contentUri, projection: projection, selection: selection, selectionArgs: selectionArgs, groupBy: groupBy, having: having, sort: sort)
    }
    
    public func query(contentUri: Uri, projection: [String]?, selection: String?, selectionArgs: [String : AnyObject]?, groupBy: String?, having: String?, sort: String?) throws -> Cursor {
        let contentProvider = try self.getContentProviderFor(contentUri)
        return try contentProvider!.query(contentUri, projection: projection, selection: selection, selectionArgs: selectionArgs, groupBy: groupBy, having: having, sort: sort)
    }
    
    public func registerContentObserver(contentUri: Uri, notifyForDescendents: Bool, contentObserver: ContentObserver) {
        let key = "\(contentObserver.dynamicType)"
        var registrations = self.contentObservers[key]
        if registrations == nil {
            registrations = [ContentRegistration]()
            self.contentObservers[key] = registrations
        }
        
        let registration = ContentRegistration(contentObserver: contentObserver, contentUri: contentUri, notifyForDescendents: notifyForDescendents)
        guard !registrations!.contains(registration) else {
            return
        }
        
        registrations?.append(registration)
    }
    
    public func unregisterContentObserver(contentObserver: ContentObserver) {
        let key = "\(contentObserver.dynamicType)"
        self.contentObservers.removeValueForKey(key)
    }
    
    public func update(contentUri: Uri, values: [String : AnyObject], selection: String?, selectionArgs: [String]?) throws -> Int {
        let contentProvider = try self.getContentProviderFor(contentUri)
        return try contentProvider!.update(contentUri, values: values, selection: selection, selectionArgs: selectionArgs)
    }
    
    public func update(contentUri: Uri, values: [String : AnyObject], selection: String?, selectionArgs: [String : AnyObject]?) throws -> Int {
        let contentProvider = try self.getContentProviderFor(contentUri)
        return try contentProvider!.update(contentUri, values: values, selection: selection, selectionArgs: selectionArgs)
    }
    
    func initialize() {
        self.prependContentAuthorityBaseToContentRegistrations()
    }
    
    func getContentAuthority(contentUri: Uri) -> String? {
        let uris = self.contentRegistrations.keys.array.filter() { (registeredUriString) in
            return contentUri.absoluteString.hasPrefix(registeredUriString)
        }
        
        return uris.count > 0 ? uris.first : nil
    }
    
    func getContentProviderFor(contentUri: Uri) throws -> ContentProvider? {
        guard let contentAuthorityUri = self.getContentAuthority(contentUri) else {
            throw ContentProviderError.NoRegisteredContentProvider
        }
        
        var contentProvider = self.activeContentProviderRegistry[contentAuthorityUri]
        if contentProvider == nil {
            contentProvider = try self.contentProviderFactory.create(self.contentRegistrations[contentAuthorityUri]!)
            contentProvider?.contentResolver = self
            contentProvider?.onCreate()
            self.activeContentProviderRegistry[contentAuthorityUri] = contentProvider
        }
        
        return contentProvider
    }
    
    func prependContentAuthorityBaseToContentRegistrations() {
        var adjustedRegistrations : [String : NSObject.Type] = [:]
        for (path, type) in self.contentRegistrations {
            adjustedRegistrations["content://\(self.contentAuthorityBase).\(path)"] = type
        }
        
        self.contentRegistrations = adjustedRegistrations
    }
}

func == (one: ContentRegistration, other: ContentRegistration) -> Bool {
    return one.contentUri.isEqual(other.contentUri)
}

class ContentRegistration : Equatable {
    let contentObserver : ContentObserver
    let contentUri : Uri
    let notifyForDescendents : Bool
    
    init(contentObserver: ContentObserver, contentUri: Uri, notifyForDescendents: Bool) {
        self.contentObserver = contentObserver
        self.contentUri = contentUri
        self.notifyForDescendents = notifyForDescendents
    }
}