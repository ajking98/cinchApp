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
    
    private var DB = Database.database().reference().child("tags")
    
    
    ///Gets the whole element at a given link
    func readElement(tagLabel : String, link : String, completion : @escaping (TagElement) -> Void){
        DB.child(tagLabel).child("elements").child(link).observeSingleEvent(of: .value) { (snapshot) in
            if let element = snapshot.value as? [String : Any] {
                let firstUsed = element["firstUsed"] as! Double
                let lastUsed = element["lastUsed"] as! Double
                let link = element["link"] as! String
                let numOfUsages = element["numOfUsages"] as! Int
                completion(TagElement(link: link, numOfUsages: numOfUsages, lastUsed: lastUsed, firstUsed: firstUsed))
            }
        }
        
        TagElementStruct().updateNumOfUsages(tagLabel: tagLabel, link: link)
        TagElementStruct().updateLastUsed(tagLabel: tagLabel, link: link, newLastUsedValue: NSDate().timeIntervalSince1970)
    }
    
    ///reads all the elements for a given tag label
    func readAllElements(tagLabel : String, completion : @escaping([TagElement])->Void){
        DB.child(tagLabel).child("elements").observeSingleEvent(of: .value) { (snapshot) in
            if let elements = snapshot.value as? [String : [String : Any]] {
                var elementsDict : [TagElement] = []
                for thisElement in elements {
                    if let element = elements[thisElement.key] {
                        let firstUsed = element["firstUsed"] as! Double
                        let lastUsed = element["lastUsed"] as! Double
                        let link = element["link"] as! String
                        let numOfUsages = element["numOfUsages"] as! Int
                        
                        let tagElement = TagElement(link: link, numOfUsages: numOfUsages, lastUsed: lastUsed, firstUsed: firstUsed)
                        elementsDict.append(tagElement)
                    }
                }
                completion(elementsDict)
            }
        }
    }
    
    //check is data already exists in db and updates or creates depending on the outcome
    func addElement(tagLabel : String, tagElement : TagElement) {
        let link = tagElement.link
        let updatedLink = convertStringToKey(link: link)
        DB.child(tagLabel).child("elements").child(updatedLink).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? [String : Any] {
                TagElementStruct().updateNumOfUsages(tagLabel: tagLabel, link: updatedLink)
                TagStruct().updateTagOccurance(tagLabel: tagLabel)
            }
            else {
                self.createElement(tagLabel: tagLabel, newTagElement: tagElement)
            }
        }
    }
    
    
    ///Takes in a tagLabel and a new tagElement and creates the elements for the given link
    fileprivate func createElement(tagLabel : String, newTagElement : TagElement){
        let link = newTagElement.link
        let updatedLink = convertStringToKey(link: link)
        DB.child(tagLabel).child("elements").updateChildValues([updatedLink : newTagElement.toString()])
    }
    
    
    ///Takes in a tagLabel and a link to the image and deletes the tagElement at that given link in the tag object in the DB
    func deleteElement(tagLabel : String, link : String){
        DB.child(tagLabel).child("elements").child(String(link)).removeValue()
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
            if let lastUsed = snapshot.value as? Double {
                let date = NSDate(timeIntervalSince1970: lastUsed)
                action(date)
            }
        }
        return
    }
    
    
     ///Takes a tagLabel and a newLastUsedValue (Unix DateTime object) and updates the value in the DB for when the Tag was last used
    func updateLastUsed(tagLabel : String, newLastUsedValue : TimeInterval){
        DB.child(tagLabel).child("lastUsed").setValue(newLastUsedValue)
    }
    
    
    ///Takes a tagLabel and returns the firstUsed (Unix DateTime object) value for when the Tag was first created
    func readFirstUsed(tagLabel : String, action: @escaping (NSDate) -> Void) {
        DB.child(tagLabel).child("firstUsed").observeSingleEvent(of: .value) { (snapshot) in
            if let firstUsed = snapshot.value as? Double {
                let date = NSDate(timeIntervalSince1970: firstUsed)
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
