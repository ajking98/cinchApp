//
//  The Public Taggging
//
/*
    Responsible for the interactions with the Tag object values with the database
 
 RUD commands for:  //Cannot create a tag Element because each tag is instantiated in the DB with at least one element
    1. read Elements //Returns all elements in DB
    2. update Element
    3. delete Element //deletes the element at a given index
 
 RU commands for :
    1. read tagOccurance
    2. update tagOccurance
    3. read lastUsed
    4. update lastUsed
 
 R commands for :
    1. read firstUsed
 */

import Foundation


struct TagStruct {
    
    /*
    Takes in a tagLabel and returns the list of tagElement objects that correspond with that tagLabel
     */
    func readElements(tagLabel : String)->[TagElement] {
        return [TagElement(link: "nil")]
    }
    
    
    /*
     Takes in a tagLabel and a new tagElement and appends the element to the current tagElements in the DB
     returns true if successful
    */
    func updateElement(tagLabel : String, newTagElement : TagElement)-> Bool{
        
        return true
    }
    
    
    /*
        Takes in a tagLabel and elementIndex and deletes the tagElement at that given index in the tag object in the DB
    */
    func deleteElement(tagLabel : String, elementIndex : Int)-> Bool{
        return true
    }
    
    
    /*
        Takes a tagLabel and returns the number of times that tagLabel has been used throughout the app
    */
    func readTagOccurance(tagLabel : String)-> Int{
        return 0
    }
    
    
    /*
    Takes in a tagLabel and a newTagOccurance value that represents the new integer you wish to store in the database for the tagOccurance value
    --Should be called everytime the user uses a tag (adds to the Tag Object in DB or reads from Tag Object in DB)
     //returns true if successful
    */
    func updateTagOccurance(tagLabel : String, newTagOccuranceValue : Int)->Bool{
        return true
    }
    
    
    /*
    Takes in a tagLabel and returns the last time that tag was used
    returns UNIX dateTime object
    */
    func readLastUsed(tagLabel : String)-> NSDate{
        return NSDate()
    }
    
    /*
     Takes a tagLabel and a newLastUsedValue (Unix DateTime object) and updates the value in the DB for when the Tag was last used
     returns true if successful
    */
    func updateLastUsed(tagLabel : String, newLastUsedValue : NSDate)-> Bool{
        return true
    }
    
    
    /*
     Takes a tagLabel and returns the firstUsed (Unix DateTime object) value for when the Tag was first created
    */
    func readFirstUsed(tagLabel : String) -> NSDate {
        return NSDate()
    }
}
