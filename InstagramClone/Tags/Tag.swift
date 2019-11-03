//
//  Tag.swift
//  InstagramClone
//


import Foundation


class Tag {
    var tagElements : [TagElement]?
    var tagOccurance : Int?
    var lastUsed : TimeInterval?
    var firstUsed : TimeInterval?
    var tagLabel : String?
    var numberOfElements : Int?
    
    //This init should be called when trying to add a tag the database
    init(tagLabel : String, tagElements : [TagElement]) {
        self.tagElements = tagElements
        self.tagLabel = tagLabel
        numberOfElements = 1
        tagOccurance = 1
    }
    
    
    //This init should be called when reading data from the database
    init(tagLabel : String, tagOccurance : Int, lastUsed : Double, firstUsed: Double, numberOfElements : Int, tagElements : [TagElement]){
        self.tagElements = tagElements
        self.tagOccurance = tagOccurance
        self.lastUsed = lastUsed
        self.firstUsed = firstUsed
        self.tagLabel = tagLabel
        self.numberOfElements = numberOfElements
    }
    
    func getLastUsed() ->Double{
        lastUsed = NSDate().timeIntervalSince1970
        return lastUsed!
    }
    
    
    ///converts Tag Object to dictionary 
    func toString()-> [String : Any]{
        
        firstUsed = NSDate().timeIntervalSince1970
        lastUsed = NSDate().timeIntervalSince1970
        var tagElementsDict : [String : Any] = [:]
        
        if let tagElements = tagElements {
            for element in tagElements {
                let updatedLink = convertStringToKey(link: element.link)
                tagElementsDict[updatedLink] = element.toString()
            }
        }
        
        let tagDict : [String : Any] = ["tagLabel" : self.tagLabel!, "lastUsed" : lastUsed!, "firstUsed" : firstUsed!, "numberOfElements" : numberOfElements, "tagOccurance" : tagOccurance, "elements" : tagElementsDict]
        
        return tagDict
    }
}
