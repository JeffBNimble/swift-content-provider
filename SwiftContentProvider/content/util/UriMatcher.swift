//
//  UriMatcher.swift
//  SwiftContentProvider
//
//  Created by Jeff Roberts on 7/26/15.
//  Copyright © 2015 nimbleNoggin.io. All rights reserved.
//

import Foundation

public class UriMatcher {
    public static let NO_MATCH = -1
    
    static let ALPHA_SET = NSCharacterSet.decimalDigitCharacterSet().invertedSet
    static let ALPHA_WILDCARD = "*"
    static let NUMERIC_WILDCARD = "#"
    static let TERMINAL = "!"
    
    private var matchTree : NSMutableDictionary
    
    public required init(root: Int) {
        self.matchTree = NSMutableDictionary()
        self.matchTree[UriMatcher.TERMINAL] = root
    }
    
    public func addUri(uri: Uri, matchCode: Int) -> Bool {
        let urlComponents = NSURLComponents(URL: uri, resolvingAgainstBaseURL: false)
        let scheme = urlComponents!.scheme
        let host = urlComponents!.host
        let path = urlComponents!.path
        let pathComponents = path != nil ? path!.pathComponents : [String]()
        let allComponents = [scheme!, host!] + pathComponents

        var node : NSMutableDictionary? = self.matchTree
        for urlComponent in allComponents {
            let decodedComponent = urlComponent.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            if decodedComponent == "/" {
                continue
            }
            
            node = self.appendURLComponent(decodedComponent!, node: node!)
        }
        
        if node != nil  {
            node![UriMatcher.TERMINAL] = matchCode
        }
        
        return true
    }
    
    public func match(uri: Uri) -> Int {
        let urlComponents = NSURLComponents(URL: uri, resolvingAgainstBaseURL: false)
        let scheme = urlComponents!.scheme
        let host = urlComponents!.host
        let path = urlComponents!.path
        let pathComponents = path != nil ? path!.pathComponents : [String]()
        let allComponents = [scheme!, host!] + pathComponents
        
        var node : NSMutableDictionary? = self.matchTree
        for urlComponent in allComponents {
            if urlComponent == "/" {
                continue
            }
            
            node = self.getMatchingNode(urlComponent, node: node!)
            if node == nil {
                break
            }
        }
        
        return node != nil ? node![UriMatcher.TERMINAL] as! Int : UriMatcher.NO_MATCH
    }
    
    func appendURLComponent(urlComponent: String, node: NSMutableDictionary) -> NSMutableDictionary? {
        var childNode = node[urlComponent] as? NSMutableDictionary
        if childNode == nil {
            childNode = NSMutableDictionary()
            node[urlComponent] = childNode
        }
        
        return childNode
    }
    
    func getMatchingNode(urlComponent: String, node: NSMutableDictionary) -> NSMutableDictionary? {
        let matchingNode = node[urlComponent]
        
        if matchingNode != nil {
            return matchingNode as? NSMutableDictionary
        }
        
        return ((self.isNumericURLComponent(urlComponent) ? node[UriMatcher.NUMERIC_WILDCARD] : node[UriMatcher.ALPHA_WILDCARD]) as? NSMutableDictionary)
    }
    
    func isNumericURLComponent(urlComponent: String) -> Bool {
        return (urlComponent.rangeOfCharacterFromSet(UriMatcher.ALPHA_SET)?.isEmpty)!
    }
}