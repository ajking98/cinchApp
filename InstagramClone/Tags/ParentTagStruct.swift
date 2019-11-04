//
//  The Public Taggging
//
/*
 Communicates with the Database and contains the CRUD commands to:
 1. Create Tag
 2. Read Tag
 3. Update Tag
 4. Delete Tag
 
 
 ALL methods in here would increment the tagOccurance counter by 1 EACH
 ALL methods update lastUsed value in DB
 */


import Foundation
import FirebaseDatabase


struct ParentTagStruct{
    
    var DB = Database.database().reference().child("tags")
    
    
    ///Adds Tag to database
    func addTag(tag : Tag)-> Void{
        DB.child(tag.tagLabel!).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? [String : Any] {
                self.updateTag(tag: tag)
            }
            else {
                self.createTag(tag: tag)
            }
        }
    }
    
    //Takes a tag and adds it the DB under the tag label
    private func createTag(tag : Tag)-> Void{
        print("next link is required 1")
        DB.child(tag.tagLabel!).setValue(tag.toString())
        print("required 1")
    }
    
    ///Reads all the names of every tag
    func readTagNames(completion : @escaping([String])->Void) {
        DB.observeSingleEvent(of: .value) { (snapshot) in
            if let tag = snapshot.value as? [String : Any] {
                completion(Array(tag.keys))
            }
        }
    }
    
    ///Takes a tagLabel and returns the corresponding tag object
    func readTag(tagLabel : String, completion : @escaping(Tag)->Void){
        
        DB.child(tagLabel).observeSingleEvent(of: .value) { (snapshot) in
            if let tag = snapshot.value as? [String : Any] {
                print("reading tag")
                TagStruct().readAllElements(tagLabel: tagLabel, completion: { (tagElements) in
                    
                    let firstUsed = tag["firstUsed"] as! Double
                    let lastUsed = tag["lastUsed"] as! Double
                    let numberOfElements = tag["numberOfElements"] as! Int
                    let tagLabel = tag["tagLabel"] as! String
                    let tagOccurance = tag["tagOccurance"] as! Int
                    
                    let tag = Tag(tagLabel: tagLabel, tagOccurance: tagOccurance, lastUsed: lastUsed, firstUsed: firstUsed, numberOfElements: numberOfElements, tagElements: tagElements)
                    
                    completion(tag)
                })
            }
        }
    }
    
    
    //Adds to existing tag in DB
    private func updateTag(tag : Tag)-> Void {
        guard let tagElements = tag.tagElements else { return }
        for tagElement in tagElements {
            TagStruct().addElement(tagLabel: tag.tagLabel!, tagElement: tagElement)
        }
    }
    
    
    ///Takes in a tagLabel and deletes it from the database and returns the deleted tag object
    func deleteTag(tagLabel : String)-> Void {
        DB.child(tagLabel).removeValue()
    }
    
    
    
}
