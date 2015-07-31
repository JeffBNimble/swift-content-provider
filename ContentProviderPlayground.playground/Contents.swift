//: Playground - noun: a place where people can play

import UIKit
import SwiftContentProvider
import Foundation

var str = "Hello, playground"

@objc
class CP : NSObject, ContentObserver {
    required override init() {}
    func onUpdate(contentUri: NSURL, operation: ContentOperation) {
        print("Hello")
    }
}

func createObserver(type:NSObject.Type) -> ContentObserver {
    return type.init() as! ContentObserver
}

let cp = createObserver(CP.self)
cp.onUpdate(NSURL(), operation: .Insert)

var dict:[String:String] = ["Hi":"x", "There":"y"]


let d2 = dict.map() { (key, value) in
    return (key + "yo", value + "y")
}

let observers = ["Me":[1, 2, 3], "You":[4, 5, 6]]
let y = observers.values.flatMap() {$0}
print("\(y)")
let x = observers.flatMap {$0.1}.filter() { (number) in number > 2 }
print("\(x)")

let matcher = UriMatcher(root: -1)
matcher.addUri(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/realm")!, matchCode: 1)
matcher.addUri(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/champion")!, matchCode: 2)
matcher.addUri(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkin")!, matchCode: 3)

var matchCode = matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/dogs")!)
matchCode = matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/champion")!)

let uriString = "content://io.nimblenoggin.LoLBookOfChampions.datadragon/champion/105"
let registeredUri = "content://io.nimblenoggin.LoLBookOfChampions.datadragon/champion/#/#"
var uri : String = registeredUri

let numericWildcardRange = registeredUri.rangeOfString("#")
numericWildcardRange?.indices

uri.replaceRange(numericWildcardRange!, with: "\\d+$")
uri = "^" + uri
var range = uriString.rangeOfString(uri, options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil)
uri.rangeOfString("#", options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil)
