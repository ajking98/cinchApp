//
//  FolderStruct2.swift
//  InstagramClone
/*
    Responsible for interacting within the Folders dropdown in the database
 
    Contains RU commands for the following variables: Read, Update
        - dateCreated
        - dateLastModified
        - icon
        - numOfImages
        - numOfVideos
        - isPrivate
 
 
    Contains CRUD commands for: Create, Read, Update, Delete (User should be able to delete a content, add a new content, update and existing content, and see a selected content)
        - content
 
 Generic Type <T> can be either the UUID (if the user hasn't set up an account yet) or a username (if one exists)
 */

import Foundation
import UIKit


struct FolderStruct {
    
    /*
     DateCreated
    */
    //returns Date the folder was created
    func readDateCreated<T>(user : T, folderName : String)-> Date{
        guard user is UUID else {
            //handle username given
            return Date()
        }
        //handle UUID given
        return Date()
    }
    
    
    //Updates the dateCreated attribute in the database and returns true if successful
    func updateDateCreated<T>(user : T, folderName : String, newDateCreated : Date) -> Bool {
        guard user is UUID else {
            //handle username given
            return true
        }
        //handle UUID given
        return true
    }
    
    
    /*
     DateLastModified
     */
    //returns the date of when the folder was last edited by the user
    func readDateLastModified<T>(user : T, folderName : String)-> Date{
        guard user is UUID else {
            //handle username given
            return Date()
        }
        //handle UUID given
        return Date()
    }
    
    
    //Updates the dateLastModified attribute in the database
    //should be called once the user makes any edits on a folder
    func updateDateLastModified<T>(user : T, folderName : String, newDateLastModified : Date) -> Bool {
        guard user is UUID else {
            //handle username given
            return true
        }
        //handle UUID given
        return true
    }
    
    
    /*
     Icon
    */
    //gets the icon for the folder from the database
    func readIcon<T>(user : T, folderName : String) -> UIImage {
        guard user is UUID else {
            //handle username given
            return UIImage()
        }
        //handle UUID given
        return UIImage()
    }
    
    //updates the icon in the database for that given folder
    func updateIcon<T>(user : T, folderName: String, newIcon : UIImage) -> Bool {
        guard user is UUID else {
            //handle username given
            return true
        }
        //handle UUID given
        return true
    }
    
    
    /*
     numOfImages
    */
    //returns the number of Images the user has as content in that folder
    //Is helpful to the user to show some stats about each folder and helpful for us to collect data on which is more preffered (Videos or Images)
    func readNumOfImages<T>(user : T, folderName: String) -> Int {
        guard user is UUID else {
            //handle username given
            return 0
        }
        //handle UUID given
        return 0
    }
    
    
    //updates the numOfImages value in the database and returns true if done successfully
    //should be called whenever the user uploads a new image to a selected folder
    func updateNumOfImages<T>(user :T, folderName : String, newNumOfImages : Int) -> Bool {
        guard user is UUID else {
            //handle username given
            return true
        }
        //handle UUID given
        return true
    }
    
    
    
    /*
     numOfVideos
    */
    //returns the number of Videos the user has as content in that folder
    //Is helpful to the user to show some stats about each folder and helpful for us to collect data on which is more preffered (Videos or Images)
    func readNumOfVideos<T>(user : T, folderName : String) -> Int {
        guard user is UUID else {
            //handle username given
            return 0
        }
        //handle UUID given
        return 0
    }
    
    //updates the numOfVideos value in the database and returns true if done successfully
    //should be called whenever the user uploads a new video to a selected folder
    func updateNumOfVideos<T>(user : T, folderName : String, newNumOfVideos : Int) -> Bool {
        guard user is UUID else {
            //handle username given
            return true
        }
        //handle UUID given
        return true
    }
    
    /*
     isPrivate
    */
    //Checks the isPrivate attribute in the database
    //Helpful to determine if the folder should be shown publicly or not
    func readIsPrivate<T>(user :T, folderName : String) ->Bool {
        guard user is UUID else {
            //Handle username given
            return true
        }
            //Handle UUID given
        return true
    }
    
    
    //changes the value of isPrivate in the database to the given newIsPrivate boolean value
    //Is called when the user wishes to change the permission on that folder
    func updateIsPrivate<T>(user : T, folderName : String, newIsPrivate : Bool)->Bool {
        guard user is UUID else {
            //Handle username given
            return true
        }
            //Handle UUID given
        return true
    }
    
    
    
}
