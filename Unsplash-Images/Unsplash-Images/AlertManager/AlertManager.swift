//
//  AlertManager.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 04/11/23.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private init() { }
    
    func showAlert(from viewController: UIViewController, withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default,handler: nil)
            
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
