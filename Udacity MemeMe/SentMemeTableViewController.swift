//
//  SentMemeTableViewController.swift
//  Udacity MemeMe
//
//  Created by Diego Malone on 05/06/21.
//

import Foundation
import UIKit

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        let item: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(SentMemeTableViewController.createMeme))
        self.navigationItem.rightBarButtonItem = item
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMemeCell", for: indexPath) as! SentMemeTableCellView
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.memeImage.image = meme.memeImage
        cell.memeText.text = "\(meme.topText) \(meme.bottomText)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    @objc func createMeme() {
        performSegue(withIdentifier: "addMeme", sender: self)
    }
}