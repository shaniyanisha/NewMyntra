//
//  imagepreviewVCViewController.swift
//  Myntra
//
//  Created by Appinventiv on 18/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

class imagepreviewVC: UIViewController {
   
    @IBOutlet weak var contentImage: UIImageView!
    
    
    var imageURL : UIImage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        
        contentImage.image = imageURL
        ///imageName.text = titleText
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
