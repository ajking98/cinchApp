//
//  Tag.swift
//  InstagramClone
//


import Foundation


class Tag {
    var tagElements : [TagElement]?
    var tagOccurance : Int?
    var lastUsed : NSDate?
    var firstUsed : NSDate?
    var tagLabel : String?
    
    //This init should be called when trying to add a tag the database
    init(tagElements : [TagElement], tagLabel : String) {
        self.tagElements = tagElements
        self.tagLabel = tagLabel
    }
    
    
    //This init should be called when reading data from the database
    init(tagElements : [TagElement], tagOccurance : Int, lastUsed : NSDate, firstUsed: NSDate, tagLabel : String){
        self.tagElements = tagElements
        self.tagOccurance = tagOccurance
        self.lastUsed = lastUsed
        self.firstUsed = firstUsed
        self.tagLabel = tagLabel
    }
}
