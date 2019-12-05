//
//  ShareViewController.swift
//  CinchShareExtension
//
//  Created by Ahmed Gedi on 11/4/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import Social
import Firebase
import MobileCoreServices


class ShareViewController: SLComposeServiceViewController {
    var selectedFolder: String = ""
    let myItem = SLComposeSheetConfigurationItem()
    var folders: [String] = [] //list of all the local user's folders
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        print("this is reached")
        return true
    }

    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    override func didSelectPost() {
        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
            let contentType = kUTTypeImage as String
            let contentType2 = kUTTypeURL as String
            
            //verify the provided data is valid
            if let contents = content.attachments as? [NSItemProvider] {
                //look for image
                for attachment in contents {
                    print("this is an item", attachment)
                    if attachment.hasItemConformingToTypeIdentifier(contentType){
                        attachment.loadItem(forTypeIdentifier: contentType, options: nil) { (data, error) in
                            var uploadingImage: UIImage?
                            switch data{
                                case let image as UIImage:
                                    print("Image tst")
                                    uploadingImage = image
                                case let data as Data:
                                    print("data tst")
                                    uploadingImage = UIImage(data: data)
                                case let url as URL:
                                    print("url tst")
                                    uploadingImage = UIImage(contentsOfFile: url.path)
                                default:
                                    print("unexpected tst")
                            }
                            if(!self.selectedFolder.isEmpty) {
                                print("here is your data marker: ", data)
                                //TODO save the image to the folder
//                                UIImage(
                            }

                            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                        }
                    }
                    
                    //handles links online
                    if attachment.hasItemConformingToTypeIdentifier(contentType2) {
                        attachment.loadItem(forTypeIdentifier: contentType2, options: nil) { (data, error) in
                            print("something : tst ", data)
                            if let link = data as? URL {
                                //TODO check if the url points to an image
                                print("this is your thingy: tst ", link)
                            }
                            
                            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                        }
                    }
                }
            }
        }
        
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        print("this is the value of the input:", self.textView.text)
    }

    
    override func configurationItems() -> [Any]! {
        myItem?.title = "Send to:"
        myItem?.value = selectedFolder //is set to the first folder by default
        myItem?.tapHandler = handleTap
        
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        guard let username = UserDefaults(suiteName: "group.com.cinch.CinchApp")?.string(forKey: defaultsKeys.usernameKey) else { return [] }//Should alert the user that they dont have an account set up
        if let tempLastUsedFolder = UserDefaults(suiteName: "group.com.cinch.CinchApp")?.string(forKey: defaultsKeys.lastUsedFolder)
        { selectedFolder = tempLastUsedFolder }
        
        UserStruct().readFolders(user: username) { (folderList) in
            self.folders = folderList
            self.myItem?.value = folderList.contains(self.selectedFolder) ? self.selectedFolder : folderList[0]
        }
        return [myItem]
    }
    
    func handleTap() {
        let vc = FolderSelection(style: .plain)
        vc.folders = folders
        vc.pendingFunction = resetSelectedFolder
        pushConfigurationViewController(vc)
    }
    
    func resetSelectedFolder(folderName: String) {
        selectedFolder = folderName
        myItem?.value = folderName
    }

}




//FolderSelection class
class FolderSelection: UITableViewController {
    var pendingFunction: ((String)->())?
    let reusableIdentifier = "Cell"
    var folders:[String] = []
    
    
    var DB = Database.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register a cell for the table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as! UITableViewCell
        cell.textLabel?.text = folders[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folderName = folders[indexPath.row]
        pendingFunction?(folderName)
        UserDefaults(suiteName: "group.com.cinch.CinchApp")?.set(folderName, forKey: defaultsKeys.lastUsedFolder)
        navigationController?.popViewController(animated: true)
    }
}
