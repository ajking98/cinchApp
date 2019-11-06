//
//  SideMenuTableViewController.swift
//  profilePageTest
//
//  Created by Ahmed Gedi on 6/30/19.
//  Copyright © 2019 Ahmed Gedi. All rights reserved.
//
import UIKit

class SideMenuViewController: UIViewController {
    enum MenuSection {
        case General
        case Logout
    }
    enum MenuItem {
        case Private
        case NightMode
        case ProfileSettings
        case SendFeedback
        case ReportBug
        case Share
        case Logout
    }
    
    struct Section {
        var type: MenuSection
        var items: [MenuItem]
    }
    
    let reuseIdentifier = "MenuCell"
    var sections = [Section]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        
    }
    
    func configureTableView() {
        sections.append(Section(type: .General, items: [.Private, .NightMode, .ProfileSettings, .SendFeedback, .ReportBug, .Share]))
        sections.append(Section(type: .Logout, items: [.Logout]))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        cell.selectionStyle = .none
        let switchDemo = UISwitch(frame:CGRect(x: 0, y: 10, width: 150, height: 300))
        switchDemo.isOn = true
        switchDemo.setOn(false, animated: false)
        switchDemo.tintColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "arrow")
        switchDemo.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        switch sections[indexPath.section].items[indexPath.row] {
        case .Private:
            cell.menuLabel.text = "Private"
            cell.sideView.addSubview(switchDemo)
        case .NightMode:
            cell.menuLabel.text = "Night Mode"
            cell.sideView.addSubview(switchDemo)
        case .ProfileSettings:
            cell.menuLabel.text = "Profile Settings"
        case .SendFeedback:
            cell.menuLabel.text = "Send Feedback"
        case .ReportBug:
            cell.menuLabel.text = "Report Problem"
        case .Share:
            cell.menuLabel.text = "Share"
        case .Logout:
            cell.menuLabel.text = "Logout"
        }
        return cell
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        if (sender.isOn == true){
            print("on")
        }
        else{
            print("off")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = sections[indexPath.section].items[indexPath.row]
        print(item)
        if !(item == .Private || item == .NightMode || item == .Share || item == .Logout) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Toggle Side Menu"), object: nil)
            let vc = storyboard?.instantiateViewController(withIdentifier: "\(item)")
    
            self.present(vc!, animated: true, completion: nil)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
