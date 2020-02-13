//
//  FolderSelectedController.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/3/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class FolderSelectedController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    //Data given by the presenting vc
    var folderName = ""
    var username = ""
    
    
    var localUser = ""
    var content: [String] = [] //this should be using a cash
    let identifier = "Cell"
    
    
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        fetchContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
    }
    
    func setup(username: String, folderName: String) {
        self.username = username
        self.folderName = folderName
    }
    
    func setupNavigationBar() {
        tabBarController?.tabBar.isHidden = true
        title = folderName
        view.backgroundColor = .white
        

        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon-black"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        let leftNavItem = UIBarButtonItem(customView: backButton)
        navigationItem.setLeftBarButton(leftNavItem, animated: false)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //check if the folder is aleady being followed and if it is the local user
        guard let localUser = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        self.localUser = localUser
//        if localUser == username { return }
        let plusButton = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(handleFollowFolder))
        navigationItem.setRightBarButton(plusButton, animated: false)
        
        UserStruct().readFoldersReference(user: username) { (folderRefs) in
            print("this is something")
            if (folderRefs.contains { (folderRef) -> Bool in  return folderRef.folderName == self.folderName && folderRef.admin == self.username }) { //returns true if current folder is already followed
                print("this is something here dudeed")
                let minusButton = UIBarButtonItem(title: "Unfollow", style: .plain, target: self, action: #selector(self.handleUnFollowFolder))
                self.navigationItem.setRightBarButton(minusButton, animated: false)
            }
        }
    }
    
    @objc func handleUnFollowFolder() {
        print("this is unfollowing")
        let plusButton = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(handleFollowFolder))
        navigationItem.setRightBarButton(plusButton, animated: false)
        let folderRef = FolderReference(admin: username, folderName: folderName)
        UserStruct().deleteFolderReference(user: localUser, folder: folderRef)
    }

    
    @objc func handleFollowFolder() {
        let minusButton = UIBarButtonItem(title: "Unfollow", style: .plain, target: self, action: #selector(handleUnFollowFolder))
        navigationItem.setRightBarButton(minusButton, animated: false)
        print("this is following")
        let folderRef = FolderReference(admin: username, folderName: folderName)
        UserStruct().addFolderReference(user: localUser, newFolder: folderRef)
    }
    
    func setupCollectionView() {
        collectionView.register(GenericCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.top = 16
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        //constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    
    func fetchContent() {
        FolderStruct().readContent(user: username, folderName: folderName) { (content) in
            self.content = content
            self.collectionView.reloadData()
        }
    }
    
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GenericCell
        cell.backgroundColor = .lightGray
        cell.setup(link: content[indexPath.item])
        return cell
    }
    
    
    //summons the table with fullscreen cells
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Discover", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CellSelected") as! CellSelectedTable
        vc.modalPresentationStyle = .fullScreen
        vc.content = content
        vc.startingIndex = indexPath
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/3 - 1.5, height: (collectionView.bounds.width)/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
          return true
      }
    
    
}
 


