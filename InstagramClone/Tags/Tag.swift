//
//  Tag.swift
//  InstagramClone
//


import Foundation


class Tag {
    var tagElement : TagElement?
    var tagOccurance : Int?
    var lastUsed : NSDate?
    var firstUsed : NSDate?
    var tagLabel : String?
    var numberOfElements : Int?
    
    //This init should be called when trying to add a tag the database
    init(tagElement : TagElement, tagLabel : String) {
        self.tagElement = tagElement
        self.tagLabel = tagLabel
        numberOfElements = 1
        tagOccurance = 1
    }
    
    
    //This init should be called when reading data from the database
    init(tagElement : TagElement, tagOccurance : Int, lastUsed : NSDate, firstUsed: NSDate, tagLabel : String, numberOfElements : Int){
        self.tagElement = tagElement
        self.tagOccurance = tagOccurance
        self.lastUsed = lastUsed
        self.firstUsed = firstUsed
        self.tagLabel = tagLabel
        self.numberOfElements = numberOfElements
    }
    
    func getLastUsed() ->NSDate{
        lastUsed = NSDate()
        return lastUsed!
    }
    
    
    ///converts Tag Object to dictionary 
    func toString()-> [String : Any]{
        
        firstUsed = NSDate()
        lastUsed = NSDate()
        let tagDict : [String : Any] = ["tagLabel" : self.tagLabel!, "lastUsed" : Int(lastUsed!.timeIntervalSince1970), "firstUsed" : Int(firstUsed!.timeIntervalSince1970), "numberOfElements" : numberOfElements, "tagOccurance" : tagOccurance]
        
        return tagDict
    }
}