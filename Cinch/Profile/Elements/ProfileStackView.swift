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
    var upperInnerStackView = UIStackView(frame: CGRect.zero)
    var lowerInnerStackView = UIStackView(frame: CGRect.zero)
    
    var followings = 0
    var followers = 0
    var likes = 0
    
    func setup(followings: Int, followers: Int, Likes: Int, view: UIView) {
        self.view = view
        setupStatusView()
        setupSpacingBar()
    }
    
    func setupStatusView() {
        backgroundColor = .black
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        view.addSubview(self)

        setupInnerStackView()
        
        //constraints
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: view.frame.height/14).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.width*0.8).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.32).isActive = true
        
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
        setupInnerStackViewData("Likes", likes)
    }
    
    
    func setupInnerStackViewData(_ variableName: String, _ value: Int) {
        let view = UIView()
        let numberLabel = UILabel()
        let textLabel = UILabel()
        numberLabel.text = "\(likes)"
        textLabel.text = variableName
        textLabel.textColor = .gray
        numberLabel.textAlignment = .center
        textLabel.textAlignment = .center
        view.addSubview(numberLabel)
        view.addSubview(textLabel)
        upperInnerStackView.addArrangedSubview(numberLabel)
        lowerInnerStackView.addArrangedSubview(textLabel)
    }
    
    
    //Try to add this to the stackview and not the parent view
    func setupSpacingBar() {
        let bar = UIView(frame: CGRect(x: view.frame.width/2.8, y: (view.center.y)/1.55, width: 1, height: 40))
        bar.backgroundColor = .lightGray
        view.addSubview(bar)
        
        let bar2 = UIView(frame: CGRect(x: view.frame.width/1.55, y: (view.center.y)/1.55, width: 1, height: 40))
        bar2.backgroundColor = .lightGray
        view.addSubview(bar2)
    }
}
