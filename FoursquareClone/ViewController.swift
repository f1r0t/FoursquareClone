//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Fırat AKBULUT on 21.10.2023.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    
    @IBAction func signInPressed(_ sender: UIButton) {
        if let userName = userNameText.text, let password = passwordText.text{
            
            PFUser.logInWithUsername(inBackground: userName, password: password) {(user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: self)
                } else {
                    self.makeAlert(title: "Error!", message: error!.localizedDescription)
                }
            }
        }
    }
    @IBAction func signUpPressed(_ sender: UIButton) {
        if userNameText.text != "" && passwordText.text != ""{
            let user = PFUser()
            user.username = userNameText.text
            user.password = passwordText.text
            user.signUpInBackground { (success, error) in
                if let e = error {
                    self.makeAlert(title: "Error", message: e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: self)
                }
            }
            
        }else {
            makeAlert(title: "Error!", message: "Username / password??")
        }
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}



