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
        print("adding Tag...")
        DB.observeSingleEvent(of: .value) { (snapshot) in
            if(snapshot.hasChild(tag.tagLabel!)) {
                self.updateTag(tag: tag)
            }else{
                self.createTag(tag: tag)
            }
        }
        TagStruct().updateTagOccurance(tagLabel: tag.tagLabel!)
        TagStruct().updateLastUsed(tagLabel: tag.tagLabel!, newLastUsedValue: NSDate())
        return
    }
    
    
    //Takes a tag and adds it the DB under the tag label
    private func createTag(tag : Tag)-> Void{
        print("Creating Tag...")
        DB.child(tag.tagLabel!).setValue(tag.toString())
        DB.child(tag.tagLabel!).child("tagElements").child("0").setValue(tag.tagElement?.toString())
        
        return
    }
    
    
    ///Takes a tagLabel and returns the corresponding tag object
    func readTag(tagLabel : String)-> Tag{
        TagStruct().updateTagOccurance(tagLabel: tagLabel)
        TagStruct().updateLastUsed(tagLabel: tagLabel, newLastUsedValue: NSDate())
        
        return Tag(tagElement: TagElement(link: "nil"), tagLabel: "nil")
    }
    
    
    //Adds to existing tag in DB
    private func updateTag(tag : Tag)-> Void {
        print("updating Tag...")
        
        guard let tagLabel = tag.tagLabel else {
            return
        }
        DB.child(tagLabel).child("numberOfElements").observeSingleEvent(of: .value) { (snapshot) in
            if let index = snapshot.value as? Int {
                TagStruct().updateElement(tagLabel: tagLabel, index: index, newTagElement: tag.tagElement!)
                TagStruct().updateNumberOfElements(tagLabel : tagLabel, newNumber: index + 1)
            }
        }
        return
    }
    
    
    ///Takes in a tagLabel and deletes it from the database and returns the deleted tag object
    func deleteTag(tagLabel : String)-> Void {
        DB.child(tagLabel).removeValue()
    }
    
    
    
}
