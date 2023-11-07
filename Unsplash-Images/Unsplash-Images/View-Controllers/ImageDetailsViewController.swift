//
//  ImageDetailsViewController.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 31/10/23.
//

import UIKit
import Reachability
class ImageDetailsViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var displayImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var twitterUserName: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    let reachability = try! Reachability()

    private var viewmodel = ImageDetailsViewModel()
    var displayDetails = Result(id: nil, slug: nil, created_at: nil, description: nil, alt_description: nil, urls: nil, user: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        viewmodel.setDetails(displayDetails, self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           DispatchQueue.main.async {
               self.reachability.whenReachable = { reachability in
                   if reachability.connection == .wifi {
                       print("Reachable via WiFi")
                   } else {
                       print("Reachable via Cellular")
                   }
                   self.view.window?.rootViewController?.dismiss(animated: true)
               }
               self.reachability.whenUnreachable = { _ in
                   print("Not reachable")
                   if let networkVC = self.storyboard?.instantiateViewController(identifier: "NoInternetViewController") as? NoInternetViewController{
                       self.spinner.stopAnimating()
                       self.present(networkVC, animated: true)
                   }
               }
               
               do {
                   try self.reachability.startNotifier()
               } catch {
                   print("Unable to start notifier")
               }
           }
    }
   
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
