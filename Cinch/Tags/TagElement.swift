//
//  TagElement.swift
//  Cinch
//

import Foundation

class TagElement {

    
    var link : String = ""
    var numOfUsages : Int?
    var lastUsed : Double?
    var firstUsed : Double?
    var contentKey = ""
    
    
    //This init should be called when trying to add a tagElement Object to the database
    init(link : String, contentKey: String) {
        self.link = link
        self.firstUsed = Date().timeIntervalSince1970
        self.lastUsed = Date().timeIntervalSince1970
        self.numOfUsages = 1
        self.contentKey = contentKey
    }
    
    //This init should be called when reading data from the database with a tagIndex
    init(link : String, numOfUsages : Int, lastUsed : TimeInterval, firstUsed : TimeInterval, contentKey: String){
        self.link = link
        self.numOfUsages = numOfUsages
        self.lastUsed = lastUsed
        self.firstUsed = firstUsed
        self.contentKey = contentKey
    }
    
    func toString()-> [String : Any]{
        let tagDict : [String : Any] = ["link" : link, "numOfUsages" : numOfUsages!, "lastUsed" : lastUsed!, "firstUsed" : firstUsed!, "contentKey": contentKey]
        
        return tagDict
    }
}
