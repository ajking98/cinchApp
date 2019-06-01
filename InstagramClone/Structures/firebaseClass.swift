//
//  firebaseClass.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/1/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation

class firebaseClass {
    var user:userStruct
    var tags:tagStruct
    var folder:folderStruct
    
    init(user: userStruct, tags:tagStruct, folder: folderStruct) {
        self.user = user
        self.tags = tags
        self.folder = folder
    }
    
    func getName() -> String {
        return user.getName()
    }
    
    func changeName(newName:String) {
        user.setName(newName: newName)
    }
    
    func getPassword() -> String {
        return user.getPassword()
    }
    
    func changePassword(newPassword:String) {
        user.setPassword(newPassword: newPassword)
    }
    
    func getProfilePic() -> String {
        return user.getProfilePic()
    }
    
    func changeProfilePic(newProfilePic:String) {
        user.setProfilePic(newProfilePic: newProfilePic)
    }
    
    func getEmail() -> String {
        return user.getEmail()
    }
    
    func changeEmail(newEmail:String) {
        user.setEmail(newEmail: newEmail)
    }
    
    func getPrivateOrPublic() -> Bool {
        return user.getPrivateOrPublic()
    }
    
    func changePrivateOrPublic(newPrivateOrPublic:Bool) {
        user.setPrivateOrPublic(newPrivateOrPublic: newPrivateOrPublic)
    }
    
    func getUser() -> userStruct {
        return user
    }
    
    func createNewUser(uuid:String, newName:String, newPassword:String, newEmail:String, newProfilePic:String, newPrivateOrPublic:Bool, newTags:tagStruct) -> userStruct {
        var newUser = userStruct(uuid: uuid, name: newName, password: newPassword, email: newEmail, profilePic: newProfilePic, privateOrPublic: newPrivateOrPublic, tags: newTags)
        return newUser
    }
    
    func getTag() -> tagStruct {
        return tags
    }
    
    func getTageName(tags:tagStruct) -> String {
        return tags.getName()
    }
    
    func getTagImages(tags:tagStruct) -> [String] {
        return tags.getTagImages()
    }
    
    func createNewTag(newTagName:String, newTagImages:[String]) -> tagStruct {
        var newTag = tagStruct(tagName: newTagName, tagImages: newTagImages)
        return newTag
    }
    
    func changeTagName(newTageName:String) {
        tags.setName(newName: newTageName)
    }
    
    func addImageToTag(imageUrl:String) {
        var imageArray = tags.getTagImages()
        imageArray.append(imageUrl)
    }
    
    func deleteImageFromTag(tagName:String, imageUrl:String) {
        var tagArray = tags.getTagImages()
        if let index = tagArray.firstIndex(of: imageUrl) {
            tagArray.remove(at: index)
        }
        
    }
    
    func getFolder() -> folderStruct {
        return folder
    }
    
    func getFolderName() -> String {
        return folder.getName()
    }
    
    func changeFolderName(newName:String) {
        folder.setName(newName: newName)
    }
    
    func getIconImage() -> String {
        return folder.getIconImage()
    }
    
    func changeIconImage(newIconImage:String) {
        folder.setIconImage(newIconImage: newIconImage)
    }
    
    func getNumOfImages() -> Int {
        return folder.getNumOfImages()
    }
    
    func changeNumOfImages(newNumOfImages:Int) {
        folder.setNumOfImages(newNumOfImages: newNumOfImages)
    }
    
    func getNumOfVideos() -> Int {
        return folder.getNumOfVideos()
    }
    
    func changeNumOfVideos(newNumOfVideos:Int) {
        folder.setNumOfVideos(newNumOfVideos: newNumOfVideos)
    }
    
    func getFolderPrivateOrPublic() -> Bool {
        return folder.getPrivateOrPublic()
    }
    
    func changeFolderPrivateOrPublic(newPrivateOrPublic:Bool) {
        folder.setPrivateOrPublic(newPrivateOrPublic: newPrivateOrPublic)
    }
    
    func getFolderDateCreated() -> String {
        return folder.getDateCreated()
    }
    
    func changeFolderDateCreated(newDateCreated:String) {
        folder.setDateCreated(newDateCreated: newDateCreated)
    }
    
    func getFolderDateModified() -> String {
        return folder.getDateModified()
    }
    
    func changeFolderDateModified(newDateModified:String) {
        folder.setDateModified(newDateModified: newDateModified)
    }
    
    func getImages() -> [String] {
        return folder.getImages()
    }
    
    func changeImages(newImages:[String]) {
        folder.setImages(newImages: newImages)
    }
    
    func addImageToFolder(newImageUrl:String) {
        var imageArray = folder.getImages()
        imageArray.append(newImageUrl)
    }
    
    func deleteImageFromFolder(folderName:String, imageUrl:String)   {
        var imageArray = folder.getImages()
        if let index = imageArray.firstIndex(of: imageUrl) {
            imageArray.remove(at: index)
        }
    }
    
    func getFolderVideos() -> [String] {
        return folder.getVideos()
    }
    
    func changeFolderVideos(newVideos:[String]) {
        folder.setVideos(newVideos: newVideos)
    }
    
    func addVideoToFolder(newVideoUrl:String) {
        var videoArray = folder.getVideos()
        videoArray.append(newVideoUrl)
    }
    
    func deleteVideoFromFolder(folderName:String, videoUrl:String)   {
        var videoArray = folder.getVideos()
        if let index = videoArray.firstIndex(of: videoUrl) {
            videoArray.remove(at: index)
        }
    }
    
    func createNewFolder(newFolderName:String, newIconImage:String, newNumOfImages:Int, newNumOfVideos:Int, newPrivateOrPublic:Bool, newDateCreated:String, newDateModified:String, newImgs:[String], newVideos:[String]) -> folderStruct {
        var newFolder = folderStruct(folderName: newFolderName, iconImage: newIconImage, numOfImages: newNumOfImages, numOfVideos: newNumOfVideos, privateOrPublic: newPrivateOrPublic, dateCreated: newDateCreated, dateModified: newDateModified, imgs: newImgs, videos: newVideos)
        return newFolder
    }
}
