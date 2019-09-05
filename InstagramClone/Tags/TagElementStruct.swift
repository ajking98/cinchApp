//
//  TagElementStruct.swift
//  InstagramClone
//
/*
 Responsible for the RU commands for the tag Elements : MUST take in a link to know which one to delete
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
    
    
    ///Takes in a tagLabel and an a link and returns the link that correspond with that tagLabel at that given link
    func readLink(tagLabel : String, link : String, action : @escaping (String) ->Void){
        DB.child(tagLabel).child("elements").child(link).child("link").observeSingleEvent(of: .value) { (snapshot) in
            if let link = snapshot.value as? String {
                action(link)
            }
        }
        return
    }
    
    
    
    ///Takes in a tagLabel and a link and returns the number of times that element has been used
    func readNumOfUsages(tagLabel : String, link : String, action : @escaping (Int) -> Void) {
        DB.child(tagLabel).child("elements").child(link).child("numOfUsages").observeSingleEvent(of: .value) { (snapshot) in
            if let numOfUsages = snapshot.value as? Int {
                action(numOfUsages)
            }
        }
    }
    
    ///Takes tagLabel, link, and newNumOfUsages and updates the existing value in the DB to the new given value
    func updateNumOfUsages(tagLabel : String, link : String, newNumOfUsages : Int){ DB.child(tagLabel).child("elements").child(link).child("numOfUsages").setValue(newNumOfUsages)
    }
    
    ///increments the number for a given tag Element by one point
    func updateNumOfUsages(tagLabel: String, link : String){
        readNumOfUsages(tagLabel: tagLabel, link: link) { (numberOfUsages) in
            self.updateNumOfUsages(tagLabel: tagLabel, link: link, newNumOfUsages: Int(numberOfUsages + 1))
        }
        return
    }
    
    
    
    ///Fetches the time that tag element was last used
    func readLastUsed(tagLabel : String, link : String, action : @escaping (NSDate) -> Void) {
        DB.child(tagLabel).child("elements").child(link).child("lastUsed").observeSingleEvent(of: .value) { (snapshot) in
            if let lastUsed = snapshot.value as? Double {
                let date = NSDate(timeIntervalSince1970: lastUsed)
                action(date)
            }
        }
        return
    }
    
    ///updates the dateTime for the tagElement
    func updateLastUsed(tagLabel : String, link : String, newLastUsedValue : TimeInterval){ DB.child(tagLabel).child("elements").child(link).child("lastUsed").setValue(newLastUsedValue)
    }
    
    
    
    ///Gives the time the Tag elements was first created
    func readFirstUsed(tagLabel : String, link : String, action : @escaping (NSDate) -> Void){
        DB.child(tagLabel).child("elements").child(link).child("firstUsed").observeSingleEvent(of: .value) { (snapshot) in
            if let firstUsed = snapshot.value as? Double {
                let date = NSDate(timeIntervalSince1970: firstUsed)
                action(date)
            }
        }
        return
    }
    
    
    
}
