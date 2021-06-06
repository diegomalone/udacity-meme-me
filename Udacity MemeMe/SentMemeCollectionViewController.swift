//
//  SentMemeCollectionViewController.swift
//  Udacity MemeMe
//
//  Created by Diego Malone on 05/06/21.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(SentMemeTableViewController.createMeme))
        self.navigationItem.rightBarButtonItem = item
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sentMemeCollectionCell", for: indexPath) as! SentMemeCollectionCellView
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.memeImage.image = meme.memeImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    @objc func createMeme() {
        performSegue(withIdentifier: "addMeme", sender: self)
    }
}
