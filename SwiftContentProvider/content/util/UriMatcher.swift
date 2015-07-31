//
//  UriMatcher.swift
//  SwiftContentProvider
//
//  Created by Jeff Roberts on 7/26/15.
//  Copyright © 2015 nimbleNoggin.io. All rights reserved.
//

import Foundation

public typealias NoMatch = UriMatcher.NoMatch

public class UriMatcher {
    public enum NoMatch : MatchedUri {
        case NoMatch
        
        public func isEqual(another: MatchedUri) -> Bool {
            guard another.dynamicType == self.dynamicType else {
                return false
            }
            
            return true
        }
    }
    
    public static let NO_MATCH = NoMatch.NoMatch
    
    static let ALPHA_SET = NSCharacterSet.decimalDigitCharacterSet().invertedSet
    static let ALPHA_WILDCARD = "/*"
    static let NUMERIC_WILDCARD = "/#"
    
    static private let REGEX_MATCH_START = "^"
    static private let REGEX_MATCH_END = "$"
    static private let REGEX_MATCH_NUMBERS = "/\\d+"
    static private let REGEX_MATCH_ALPHA = "/\\d*[a-zA-Z][a-zA-Z0-9]*"
    
    private var uris : [String : MatchedUri] = [:]
    
    public required init() {
    }
    
    public func addUri(uri: Uri, matchedUri: MatchedUri) {
        guard var uriString = uri.absoluteString.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        
        var done = false
        
        // Search for and replace all alpha wildcards in the registered uri
        while !done {
            let range = self.rangeOfStringInUri(uriString, string: UriMatcher.ALPHA_WILDCARD)
            if range == nil {
                done = true
                continue
            }
            
            uriString.replaceRange(range!, with: UriMatcher.REGEX_MATCH_ALPHA)
        }
        
        done = false
        
        // Search for and replace all numeric wildcards in the registered uri
        while !done {
            let range = self.rangeOfStringInUri(uriString, string: UriMatcher.NUMERIC_WILDCARD)
            if range == nil {
                done = true
                continue
            }
            
            uriString.replaceRange(range!, with: UriMatcher.REGEX_MATCH_NUMBERS)
        }
        
        uriString = UriMatcher.REGEX_MATCH_START + uriString + UriMatcher.REGEX_MATCH_END
        self.uris[uriString] = matchedUri
    }
    
    public func match(uri: Uri) -> MatchedUri {
        guard let uriString = uri.absoluteString.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) else {
            return UriMatcher.NO_MATCH
        }
        
        for (registeredUri, matchCode) in self.uris {
            guard let _ = uriString.rangeOfString(registeredUri, options: .RegularExpressionSearch, range: nil, locale: nil) else {
                continue
            }
            
            return matchCode
        }
        
        return UriMatcher.NO_MATCH
    }
    
    private func rangeOfStringInUri(uri: String, string : String) -> Range<String.Index>? {
        return uri.rangeOfString(string)
    }
    
}

public func ==(first: MatchedUri, second: MatchedUri) -> Bool {
    return first.isEqual(second)
}

public protocol MatchedUri {
    func isEqual(another: MatchedUri) -> Bool
}