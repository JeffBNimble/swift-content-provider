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

// Create an enum for the types of Uri's we want to match
enum DataDragonUris : MatchedUri {
    case Realm, Champions, ChampionSkins, ChampionSkinsForChampion, Champion, ChampionSkin
    
    func isEqual(another: MatchedUri) -> Bool {
        guard let otherUri = another as? DataDragonUris else {
            return false
        }
        
        return otherUri.hashValue == self.hashValue
    }
    
}
// Create a UriMatcher and register some Uri's
let matcher = UriMatcher()
matcher.addUri(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/realm")!, matchedUri: DataDragonUris.Realm)
matcher.addUri(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/champion")!, matchedUri: DataDragonUris.Champions)
matcher.addUri(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkin")!, matchedUri: DataDragonUris.ChampionSkins)
matcher.addUri(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkin/*")!, matchedUri: DataDragonUris.ChampionSkinsForChampion)
matcher.addUri(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkin/*/#")!, matchedUri: DataDragonUris.ChampionSkin)

// Try to match some Uri's
matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/dogs")!) == NoMatch.NoMatch
matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/champion")!) == DataDragonUris.Champions
matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkin")!) == DataDragonUris.ChampionSkins
matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkins")!) == NoMatch.NoMatch
matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkin/Annie")!) == DataDragonUris.ChampionSkinsForChampion
matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkin/A1")!) == DataDragonUris.ChampionSkinsForChampion
matcher.match(Uri(string: "https://io.nimblenoggin.LoLBookOfChampions.datadragon/champion")!) == NoMatch.NoMatch
matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkin/Annie/105")!) == DataDragonUris.ChampionSkin
matcher.match(Uri(string: "content://io.nimblenoggin.LoLBookOfChampions.datadragon/championSkin/Annie/106/dark")!) == NoMatch.NoMatch