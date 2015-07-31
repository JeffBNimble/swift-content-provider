//
//  ContentProvider.swift
//  SwiftContentProvider
//
// ContentProvider is an object that is responsible for providing access to and manipulate content for a specific set
// of Uri's. Typically, a ContentProvider manages its content in its own SQLite database.
//
//  Created by Jeff Roberts on 7/25/15.
//  Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

import Foundation
import SwiftProtocolsSQLite

public typealias Uri = NSURL

public protocol ContentProvider {
    var contentResolver : ContentResolver { get set }
    
    /// delete: Delete zero or more rows
    /// Parameter uri: The identifying Uri to be deleted
    /// Parameter selection: The selection in parameter marker syntax used to determine which rows will be deleted.
    /// Parameter selectionArgs: An Array of arguments that will be bound into the selection
    /// Throws: A SQL error if the SQL statement fails
    /// Returns: The number of rows deleted
    func delete(uri: Uri, selection: String?, selectionArgs: [AnyObject]?) throws -> Int
    
    /// delete: Delete zero or more rows
    /// Parameter uri: The identifying Uri to be deleted
    /// Parameter selection: The selection in named parameter syntax used to determine which rows will be deleted.
    /// Parameter selectionArgs: A dictionary of named arguments that will be bound into the selection
    /// Throws: A SQL error if the SQL statement fails
    /// Returns: The number of rows deleted
    func delete(uri: Uri, selection: String?, selectionArgs: [String:AnyObject]?) throws -> Int
    
    /// insert: Insert a row
    /// Parameter uri: The identifying Uri to be inserted
    /// Parameter values: A dictionary of column names -> values that will be inserted
    /// Throws: A SQL error if the SQL statement fails
    /// Returns: The specific content Uri that was inserted
    func insert(uri: Uri, values: [String:AnyObject]) throws -> NSURL
    
    /// onCreate: Invoked when the ContentProvider is initially created
    func onCreate()
    
    /// query: Query the content
    /// Parameter uri: The identifying Uri to be queried
    /// Parameter projection: The columns to be returned in the Cursor, defaults to "*" if not specified.
    /// Parameter selection: The selection in parameter marker syntax used to determine which rows will be queried.
    /// Parameter selectionArgs: An Array of arguments that will be bound into the selection
    /// Parameter groupBy: A String containing a group by clause
    /// Parameter having: A string containing a having clause
    /// Parameter sort: A string containing the order by columns
    /// Throws: A SQL error if the SQL statement fails
    /// Returns: A Cursor of query results
    func query(uri: Uri, projection:[String]?, selection: String?, selectionArgs: [AnyObject]?, groupBy: String?, having: String?, sort: String?) throws -> Cursor
    
    /// query: Query the content
    /// Parameter uri: The identifying Uri to be queried
    /// Parameter projection: The columns to be returned in the Cursor, defaults to "*" if not specified.
    /// Parameter selection: The selection in named syntax used to determine which rows will be queried.
    /// Parameter selectionArgs: An dictionary of arguments that will be bound into the selection
    /// Parameter groupBy: A String containing a group by clause
    /// Parameter having: A string containing a having clause
    /// Parameter sort: A string containing the order by columns
    /// Throws: A SQL error if the SQL statement fails
    /// Returns: A Cursor of query results
    func query(uri: Uri, projection:[String]?, selection: String?, selectionArgs: [String:AnyObject]?, groupBy: String?, having: String?, sort: String?) throws -> Cursor
    
    /// update: Update zero or more rows
    /// Parameter uri: The identifying Uri to be updated
    /// Parameter values: A dictionary of column names -> values that will be updated
    /// Parameter selection: The selection in parameter marker syntax used to determine which rows will be updated.
    /// Parameter selectionArgs: An Array of arguments that will be bound into the selection
    /// Throws: A SQL error if the SQL statement fails
    /// Returns: The number of rows updated
    func update(uri: Uri, values: [String:AnyObject], selection: String?, selectionArgs: [AnyObject]?) throws -> Int
    
    /// update: Update zero or more rows
    /// Parameter uri: The identifying Uri to be updated
    /// Parameter values: A dictionary of column names -> values that will be updated
    /// Parameter selection: The selection in named parameter syntax used to determine which rows will be updated.
    /// Parameter selectionArgs: A dictionary of arguments that will be bound into the selection
    /// Throws: A SQL error if the SQL statement fails
    /// Returns: The number of rows updated
    func update(uri: Uri, values: [String:AnyObject], selection: String?, selectionArgs: [String:AnyObject]?) throws -> Int
}