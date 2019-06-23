//
//  TagElementStruct.swift
//  InstagramClone
//
/*
 Responsible for the RU commands for the tag Elements : MUST take in index to know which on to delete
    1. read link
    2. update link
    3. read numOfUsages
    4. update numOfUsages
    5. read lastUsed
    6. update lastUsed
 
 R commands for the following:
    1. read firstUsed
    2. read tagIndex
*/

import Foundation


struct TagElementStruct {
    
    
    /*
     Takes in a tagLabel and an elementIndex and returns the link that correspond with that tagLabel at that given index
    */
    func readLink(tagLabel : String, elementIndex : Int)-> String{
        return ""
    }
    
    /*
     Takes in a tagLabel, elementIndex, and newLink and updates the existing link for that element in the DB
     returns true if successful
    */
    func updateLink(tagLabel : String, elementIndex : Int, newLink : String)->Bool{
        return true
    }
    
    
    
    /*
     Takes in a tagLabel and elementIndex and returns the number of times that element has been used
    */
    func readNumOfUsages(tagLabel : String, elementIndex : Int) -> Int {
        return 1
    }
    
    /*
     Takes tagLabel, elementIndex, and newNumOfUsages and updates the existing value in the DB to the new given value
     returns true if successful
    */
    func updateNumOfUsages(tagLabel : String, elementIndex : Int, newNumOfUsages : Int)-> Bool{
        return true
    }
    
    
    
    /*
     Takes in a tagLabel and elementIndex and returns the Unix dateTime of when that element was last used
     */
    func readLastUsed(tagLabel : String, elementIndex : Int) -> NSDate {
        return NSDate()
    }
    
    /*
     Takes tagLabel, elementIndex, and newLastUsedValue and updates the existing Unix dateTime in the DB to the new given value
     returns true if successful
     */
    func updateNumOfUsages(tagLabel : String, elementIndex : Int, newLastUsedValue : NSDate)-> Bool{
        return true
    }
    
    
    
    /*
        Takes a tagLabel and elementIndex and returns the NSDate (Unix Timestamp) of when the Element was first created
    */
    func readFirstUsed(tagLabel : String, elementIndex : Int) -> NSDate{
        return NSDate()
    }
}
