//
//  ImageDetailsViewController.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 31/10/23.
//

import UIKit

class ImageDetailsViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var displayImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var twitterUserName: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    
    var displayDetails = Result(id: nil, slug: nil, created_at: nil, description: nil, alt_description: nil, urls: nil, user: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        ImageDetailsViewModel.shared.setDetails(displayDetails, self)
        
    }
   
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
