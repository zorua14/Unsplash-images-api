//
//  SignUpViewController.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 07/11/23.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signupbtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    @IBAction func signup(_ sender: UIButton) {
        guard let emailSend = email.text, !emailSend.isEmpty, let passwordSend = password.text, !passwordSend.isEmpty else {
            print("missing data")
            AlertManager.shared.showAlert(from: self, withTitle: "Error", message: "Enter all fields")
            return
        }
        Auth.auth().createUser(withEmail: emailSend, password: passwordSend) { (user, error) in
            if let error = error {
                AlertManager.shared.showAlert(from: self, withTitle: "SignUp Error", message: "\(error.localizedDescription)")
            } else {
                let st = UIStoryboard(name: "Main", bundle: nil)
                let vc = st.instantiateViewController(withIdentifier: "ImagesViewController") as! ImagesViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let emailSend = email.text, !emailSend.isEmpty, let passwordSend = password.text, !passwordSend.isEmpty else {
            AlertManager.shared.showAlert(from: self, withTitle: "Error", message: "Enter all fields")
            return
        }

        Auth.auth().signIn(withEmail: emailSend, password: passwordSend) { (user, error) in
            if let error = error {
                AlertManager.shared.showAlert(from: self, withTitle: "Login Error", message: "Check Your Credentials")
            } else {
                let st = UIStoryboard(name: "Main", bundle: nil)
                let vc = st.instantiateViewController(withIdentifier: "ImagesViewController") as! ImagesViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    func setUpUI(){
        email.layer.cornerRadius = 20
        email.layer.masksToBounds = true
        password.layer.cornerRadius = 20
        password.layer.masksToBounds = true
        signupbtn.layer.cornerRadius = 30
        signupbtn.layer.masksToBounds = true
        password.isSecureTextEntry = true
        password.textContentType = .oneTimeCode
    }
    
}
