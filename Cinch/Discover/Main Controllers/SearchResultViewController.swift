//
//  SearchResultViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/4/19. 
//This is the view after the user selects the term they want to search for

import UIKit
import XLActionController

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, transferDelegate {
    
    //when the user is sending a post to their profile
    //(This asks for the foldername
    func presentContent(content: SpotifyActionController) {
        present(content, animated: true, completion: nil)
    }
    //(this asks for the tags)
    func handleAlert(alert: UIAlertController) {
        present(alert, animated: true) {
            //making the alert dismissable when the user presses outside the screen
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        }
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts : [Post] = []
    var searchTerm = ""
    let tableCellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchContent(searchTerm: searchTerm)
    }
    
    //this method is called once the user has entered in a term
    func fetchContent(searchTerm : String) {
        ParentTagStruct().readTag(tagLabel: searchTerm) { (tag) in
            guard let elements = tag.tagElements else { return }
            
            //cycle through all the tag elements in the tag object
            for element in elements {
                do {
                    try ParentPostStruct().readPost(postLink: element.link, completion: { (post) in
                        let indexPath = IndexPath(item: self.posts.count, section: 0)
                        self.posts.append(post)
                        self.tableView.insertRows(at: [indexPath], with: .right)
                    })
                }
                catch {
                    print("messing up")
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! TablePostCard
        let currentPost = posts[indexPath.row]
        cell.delegate = self
        cell.buildPostCard(item: currentPost)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = posts[indexPath.row]
        guard let link = item.link else { return }
        let url = URL(string: link)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchZoomViewController") as! SearchZoomViewController
        if checkIfVideo(link: link) {
            vc.isImage = false
        } else {
            let imageView = UIImageView()
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            vc.image = imageView.image!
        }
        vc.link = link
        present(vc, animated: true, completion: nil)
    }
    
}
