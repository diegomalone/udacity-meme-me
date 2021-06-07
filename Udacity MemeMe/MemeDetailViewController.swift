//
//  MemeDetailViewController.swift
//  Udacity MemeMe
//
//  Created by Diego Malone on 06/06/21.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var memeImage: UIImageView!
    
    //MARK: Properties
    var meme: Meme!
    
    //MARK: Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeImage.image = meme.memeImage
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
}
