//
//  TagElement.swift
//  InstagramClone
//

import Foundation

class TagElement {

    
    var link : String?
    var numOfUsages : Int?
    var lastUsed : NSDate?
    var firstUsed : NSDate?
    var elementIndex : Int?
    
    
    //This init should be called when trying to add a tagElement Object to the database
    init(link : String) {
        self.link = link
        self.firstUsed = NSDate()
        self.numOfUsages = 1
    }
    
    //This init should be called when reading data from the database with a tagIndex
    init(link : String, numOfUsages : Int, lastUsed : NSDate, firstUsed : NSDate, elementIndex : Int){
        self.link = link
        self.numOfUsages = numOfUsages
        self.lastUsed = lastUsed
        self.firstUsed = firstUsed
        self.elementIndex = elementIndex
    }
    
    func toString()-> [String : Any]{
        lastUsed = NSDate()
        let tagDict : [String : Any] = ["link" : link!, "numOfUsages" : numOfUsages!, "lastUsed" : Int(lastUsed!.timeIntervalSince1970), "firstUsed" : Int(firstUsed!.timeIntervalSince1970)]
        
        return tagDict
    }
}