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
 */


import Foundation
import FirebaseDatabase


struct ParentTagStruct{
    
    var DB = Database.database().reference().child("tags")
    
    /*
     function checks if the tagLabel already exists in the database
     If it does, then calls the updateTag and adds its elements to the existing tagElements in the DB
     If it doesn't, then it calls the createTag
     */
    func addTag(tag : Tag)-> Bool{
        print("adding Tag...")
        DB.observeSingleEvent(of: .value) { (snapshot) in
            if(snapshot.hasChild(tag.tagLabel!)) {
                self.updateTag(tag: tag)
            }else{
                self.createTag(tag: tag)
            }
        }
        return true
    }
    
    
    /*
     Takes a tag and adds it the DB under the tag label
     Should only be called from inside this class
    */
    private func createTag(tag : Tag)-> Void{
        print("Creating Tag...")
        DB.child(tag.tagLabel!).setValue(tag.toString(tag : tag))
        DB.child(tag.tagLabel!).child("tagElements").child("0").setValue(tag.tagElement?.toString())
        
        return
    }
    
    
    /*
     Takes a tagLabel and returns the corresponding tag object
    */
    func readTag(tagLabel : String)-> Tag{
        
        return Tag(tagElement: TagElement(link: "nil"), tagLabel: "nil")
    }
    
    
    /*
        Takes in a tag object and adds its elements to the database -- Is called to add a tagElement to an existing tagLabel in the DB
            --This method should only be called from inside this class
    */
    private func updateTag(tag : Tag)-> Void {
        print("updating Tag...")
        
      //TODO call the updateElements method in the TagStruct
        guard let tagLabel = tag.tagLabel else {
            return
        }
//        DB.child(tagLabel).updateChildValues(tag.toString())
        
//        DB.child(tagLabel).child("numberOfElements").observe(.value) { (snapshot) in
//            print("yessir")
//            if let index = snapshot.value as? Int {
//                print("reached")
//                self.DB.child(tagLabel).child("tagElements").updateChildValues([String(index) : tag.tagElement?.toString() as Any])
//                self.DB.child(tagLabel).child("numberOfElements").setValue(index + 1)
//                self.DB.child(tagLabel).child("lastUsed").setValue(tag.getLastUsed())
//            }
//        }
        
        DB.child(tagLabel).child("numberOfElements").observeSingleEvent(of: .value) { (snapshot) in
            //TODO this whole method should just be calling other methods instead of building them out in here 
            print("yessir")
            if let index = snapshot.value as? Int {
                print("reached")
                self.DB.child(tagLabel).child("tagElements").updateChildValues([String(index) : tag.tagElement?.toString() as Any])
                //                TagStruct().updateElement(tagLabel: tagLabel, newTagElement: tag.tagElement!) TODO : un-comment when method is built
    
                self.DB.child(tagLabel).child("numberOfElements").setValue(index + 1)
                //                TagStruct().updateNumberOfElements(tagLabel : tagLabel)  TODO : un-comment when method is built
                self.DB.child(tagLabel).child("lastUsed").setValue(tag.getLastUsed())
                //                TagStruct().updateLastUsed(tagLabel: tagLabel, newLastUsedValue: tag.getLastUsed()) TODO : uncomment when method is built
            }
        }
        
        
        TagStruct().updateTagOccurance(tagLabel: tagLabel)
        return
    }
    
    
    /*
        Takes in a tagLabel and deletes it from the database and returns the deleted tag object
            -if the tagLabel doesn't exist in the database, then returns an empty tag object
    */
    func deleteTag(tagLabel : String)-> Tag {
        return Tag(tagElement: TagElement(link : "nil"), tagLabel: "nil")
    }
    
    
    
}
