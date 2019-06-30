//
//  TagElementStruct.swift
//  InstagramClone
//
/*
 Responsible for the RU commands for the tag Elements : MUST take in index to know which on to delete
    1. read numOfUsages  - Y
    2. update numOfUsages - Y
    3. read lastUsed    - Y
    4. update lastUsed     - Y
 
 R commands for the following:
    1. read firstUsed
    2. read link        - Y
 
*/

import Foundation
import FirebaseDatabase


struct TagElementStruct {
    
    var DB = Database.database().reference().child("tags")
    
    
    ///Takes in a tagLabel and an elementIndex and returns the link that correspond with that tagLabel at that given index
    func readLink(tagLabel : String, elementIndex : Int, action : @escaping (String) ->Void){
        DB.child(tagLabel).child("tagElements").child(String(elementIndex)).child("link").observeSingleEvent(of: .value) { (snapshot) in
            if let link = snapshot.value as? String {
                action(link)
            }
        }
        return
    }
    
    
    
    ///Takes in a tagLabel and elementIndex and returns the number of times that element has been used
    func readNumOfUsages(tagLabel : String, elementIndex : Int, action : @escaping (Int) -> Void) {
        DB.child(tagLabel).child("tagElements").child(String(elementIndex)).child("numOfUsages").observeSingleEvent(of: .value) { (snapshot) in
            if let numOfUsages = snapshot.value as? Int {
                action(numOfUsages)
            }
        }
    }
    
    ///Takes tagLabel, elementIndex, and newNumOfUsages and updates the existing value in the DB to the new given value
    func updateNumOfUsages(tagLabel : String, elementIndex : Int, newNumOfUsages : Int){ DB.child(tagLabel).child("tagElements").child(String(elementIndex)).child("numOfUsages").setValue(newNumOfUsages)
    }
    
    ///increments the number for a given tag Element by one point
    func updateNumOfUsages(tagLabel: String, elementIndex : Int){
        //TODO update by one increment
        readNumOfUsages(tagLabel: tagLabel, elementIndex: elementIndex) { (numberOfUsages) in
            print(numberOfUsages + 1)
            self.updateNumOfUsages(tagLabel: tagLabel, elementIndex: elementIndex, newNumOfUsages: Int(numberOfUsages + 1))
        }
        return
    }
    
    
    
    ///Fetches the time that tag element was last used
    func readLastUsed(tagLabel : String, elementIndex : Int, action : @escaping (NSDate) -> Void) {
        DB.child(tagLabel).child("tagElements").child(String(elementIndex)).child("lastUsed").observeSingleEvent(of: .value) { (snapshot) in
            if let lastUsed = snapshot.value as? Int {
                let date = NSDate(timeIntervalSince1970: Double(lastUsed))
                action(date)
            }
        }
        return
    }
    
    ///updates the dateTime for the tagElement
    func updateLastUsed(tagLabel : String, elementIndex : Int, newLastUsedValue : NSDate){ DB.child(tagLabel).child("tagElements").child(String(elementIndex)).child("lastUsed").setValue(Int(newLastUsedValue.timeIntervalSince1970))
    }
    
    
    
    ///Gives the time the Tag elements was first created
    func readFirstUsed(tagLabel : String, elementIndex : Int, action : @escaping (NSDate) -> Void){
        DB.child(tagLabel).child("tagElements").child(String(elementIndex)).child("firstUsed").observeSingleEvent(of: .value) { (snapshot) in
            if let firstUsed = snapshot.value as? Int {
                let date = NSDate(timeIntervalSince1970: Double(firstUsed))
                action(date)
            }
        }
        return
    }
    
    
    
}
