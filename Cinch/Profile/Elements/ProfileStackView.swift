//
//  profileStackView.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 1/28/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class ProfileStackView: UIStackView {

    var view = UIView(frame: CGRect.zero)
    var scrollView = UIScrollView(frame: CGRect.zero)
    var upperInnerStackView = UIStackView(frame: CGRect.zero)
    var lowerInnerStackView = UIStackView(frame: CGRect.zero)
    
    var followings = 0
    var followers = 0
    var gems = 0
//    let username = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!) //TODO: This is giving an error
    
    func setup(followings: Int, followers: Int, Gems: Int, view: UIView, scrollView: UIScrollView) {
        self.view = view
        self.scrollView = scrollView
//        self.grabData()
        setupStatusView()
        setupSpacingBar()
    }
    
//    func grabData() {
//        print(username)
//        UserStruct().readFollowing(user: username) { (followers) in
//            self.followings = followers.count
//        }
//
//        UserStruct().readFollowers(user: username) { (followers) in
//            self.followers = followers.count
//        }
//    }
    
    func setupStatusView() {
        backgroundColor = .black
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        scrollView.addSubview(self)

        setupInnerStackView()
        
        //constraints
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: view.frame.height/14).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.width*0.8).isActive = true
        topAnchor.constraint(equalTo: scrollView.topAnchor, constant: view.frame.height * 0.31).isActive = true
        
    }
    
    func setupInnerStackView() {
        upperInnerStackView.backgroundColor = .black
        upperInnerStackView.axis = .horizontal
        upperInnerStackView.alignment = .fill
        upperInnerStackView.distribution = .fillEqually
        
        lowerInnerStackView.backgroundColor = .black
        lowerInnerStackView.axis = .horizontal
        lowerInnerStackView.alignment = .fill
        lowerInnerStackView.distribution = .fillEqually
        
        addArrangedSubview(upperInnerStackView)
        addArrangedSubview(lowerInnerStackView)
        
        setupInnerStackViewData("Following", followings)
        setupInnerStackViewData("Followers", followers)
        setupInnerStackViewData("Gems", gems)
    }
    
    
    func setupInnerStackViewData(_ variableName: String, _ value: Int) {
        let view = UIView()
        let numberLabel = UILabel()
        let textLabel = UILabel()
        numberLabel.text = "\(gems)"
        textLabel.text = variableName
        textLabel.textColor = .gray
        numberLabel.textAlignment = .center
        textLabel.textAlignment = .center
        scrollView.addSubview(numberLabel)
        scrollView.addSubview(textLabel)
        upperInnerStackView.addArrangedSubview(numberLabel)
        lowerInnerStackView.addArrangedSubview(textLabel)
    }
    
    
    //Try to add this to the stackview and not the parent view
    func setupSpacingBar() {
        let bar = UIView(frame: CGRect(x: view.frame.width/2.8, y: (view.center.y)/1.55, width: 1, height: 40))
        bar.backgroundColor = .lightGray
        scrollView.addSubview(bar)
        
        let bar2 = UIView(frame: CGRect(x: view.frame.width/1.55, y: (view.center.y)/1.55, width: 1, height: 40))
        bar2.backgroundColor = .lightGray
        scrollView.addSubview(bar2)
    }
}
