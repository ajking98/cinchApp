//
//  The Public Taggging
//
/*
    Responsible for the interactions with the Tag object values with the database
 
 RUD commands for:  //Cannot create a tag Element because each tag is instantiated in the DB with at least one element
    1. read Elements //Returns all elements in DB
    2. update Element           - Y
    3. delete Element //deletes the element at a given index    -Y
 
 RU commands for :
    1. read tagOccurance    - Y
    2. update tagOccurance  - Y
    3. read lastUsed        - Y
    4. update lastUsed      - Y
    5. read numberOfElements    -Y
    6. update numberOfElements  -Y
 
 R commands for :
    1. read firstUsed       -Y
 */

import Foundation
import FirebaseDatabase


struct TagStruct {
    
    var DB = Database.database().reference().child("tags")
    
    //Takes in a tagLabel and returns the list of tagElement objects that correspond with that tagLabel
    //gets all the elements under that taglabel and puts it in a list of tagElements
    func readElements(tagLabel : String)->[TagElement] {
        return [TagElement(link: "nil")]
    }
    
    
    ///Gets the whole element at a given index 
    func readElement(tagLabel : String, elementIndex : Int, action : @escaping (Any) -> Void){
        
        TagElementStruct().updateNumOfUsages(tagLabel: tagLabel, elementIndex: elementIndex)
        TagElementStruct().updateLastUsed(tagLabel: tagLabel, elementIndex: elementIndex, newLastUsedValue: NSDate())
        return
    }
    
    
    ///Takes in a tagLabel and a new tagElement and appends the element to the current tagElements in the DB
    func updateElement(tagLabel : String, index : Int, newTagElement : TagElement){
        DB.child(tagLabel).child("tagElements").updateChildValues([String(index) : newTagElement.toString()])
    }
    
    
    ///Takes in a tagLabel and elementIndex and deletes the tagElement at that given index in the tag object in the DB
    func deleteElement(tagLabel : String, elementIndex : Int){
        DB.child(tagLabel).child("tagElements").child(String(elementIndex)).removeValue()
    }
    
    
    //Takes a tagLabel and returns the number of times that tagLabel has been used throughout the app
    func readTagOccurance(tagLabel : String, action: @escaping (Int) -> Void){
        DB.child(tagLabel).child("tagOccurance").observeSingleEvent(of: .value) { (snapshot) in
            if let tagOccurance = snapshot.value as? Int {
                action(tagOccurance)
            }
        }
    }
    
    
    //Takes in a tagLabel and a newTagOccurance value that represents the new integer you wish to store in the database for the tagOccurance value
    func updateTagOccurance(tagLabel : String, newTagOccuranceValue : Int){
        DB.child(tagLabel).child("tagOccurance").setValue(newTagOccuranceValue)
    }
    
    
    ///Increments TagOccurance by one
    func updateTagOccurance(tagLabel : String){
        readTagOccurance(tagLabel: tagLabel) { (tagOccurance) in
            self.updateTagOccurance(tagLabel: tagLabel, newTagOccuranceValue: tagOccurance + 1)
        }
        return
    }
    
    
    
    ///Takes in a tagLabel and returns the last time that tag was used
    func readLastUsed(tagLabel : String, action: @escaping (NSDate) -> Void){
        DB.child(tagLabel).child("lastUsed").observeSingleEvent(of: .value) { (snapshot) in
            if let lastUsed = snapshot.value as? Int {
                let date = NSDate(timeIntervalSince1970: Double(lastUsed))
                action(date)
            }
        }
        return
    }
    
    
     ///Takes a tagLabel and a newLastUsedValue (Unix DateTime object) and updates the value in the DB for when the Tag was last used
    func updateLastUsed(tagLabel : String, newLastUsedValue : NSDate){
        DB.child(tagLabel).child("lastUsed").setValue(Int(newLastUsedValue.timeIntervalSince1970))
    }
    
    
    ///Takes a tagLabel and returns the firstUsed (Unix DateTime object) value for when the Tag was first created
    func readFirstUsed(tagLabel : String, action: @escaping (NSDate) -> Void) {
        DB.child(tagLabel).child("firstUsed").observeSingleEvent(of: .value) { (snapshot) in
            if let firstUsed = snapshot.value as? Int {
                let date = NSDate(timeIntervalSince1970: Double(firstUsed))
                action(date)
            }
        }
        return
    }
    
    
    
    ///Reads the number of elements in a TAG
    func readNumberOfElements(tagLabel : String, action: @escaping (Int) -> Void) {
        DB.child(tagLabel).child("numberOfElements").observeSingleEvent(of: .value) { (snapshot) in
            if let numberOfElements = snapshot.value as? Int {
                action(numberOfElements)
            }
        }
    }
    
    
    //Updates the number of elements in a given tag
    func updateNumberOfElements(tagLabel : String, newNumber : Int) {
        DB.child(tagLabel).child("numberOfElements").setValue(newNumber)
    }
}
