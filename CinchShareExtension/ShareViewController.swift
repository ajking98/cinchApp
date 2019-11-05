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

class ShareViewController: SLComposeServiceViewController, FolderSelectionDelegate {
    var selectedFolder: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }

        print("fetching ref")
        print("fetching other")
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        print("this is reached")
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        print("reached here too")
        let myItem = SLComposeSheetConfigurationItem()
        myItem?.title = "" //is set to the first folder by default
        myItem?.value = "...select a folder"
        myItem?.tapHandler = handleTap
        
        return [myItem]
    }
    
    func handleTap() {
        let vc = FolderSelection(style: .plain)
        vc.delegate = self
        pushConfigurationViewController(vc)
    }

}

protocol FolderSelectionDelegate : class {
    var selectedFolder : String { get set }
}

class FolderSelection: UITableViewController {
    
    let reusableIdentifier = "Cell"
    var folders:[String] = []
    var delegate : FolderSelectionDelegate?
    
    
    var DB = Database.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFolders()
    }
    
    
    ///gets all existing folders from the DB for the local user
    func fetchFolders() {
        print("we are fetching")
        // TODO create a DB instance and call the folders
        guard let user = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        
        print("passing the defaults hear")
        DB.child(user).child("folders").observeSingleEvent(of: .value) { (snapshot) in
            print("hear we are done")
            if let folders = snapshot.value as? [String : Any] {
                var folderNames : [String] = []
                for folder in folders {
                    folderNames.append(folder.key)
                }
                folderNames.sort()
                self.folders = folderNames
                print("we are hear", folderNames)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("this is is number:", folders.count)
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as! UITableViewCell
        cell.textLabel?.text = folders[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedFolder = folders[indexPath.row]
    }
}
