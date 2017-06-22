//
//  PasswordViewController.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/21/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit

private struct Constants {
    static let userInfoSegue = "ShowToken"
}

class PasswordViewController: UIViewController {

    var email: String!

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func authorize(_ sender: UIBarButtonItem) {
        let password = passwordTextField.text!
        
        if passwordIsValid(password: password) == true {
            
            User.authorize(email: email, password: password) { user, message in
                if let message = message {
                    self.showAlert(alertTitle: "Произошла ошибка", alertMessage: message)
                } else {
                    self.performSegue(withIdentifier: Constants.userInfoSegue, sender: user!)
                }
            }
            
        } else {
            showAlert(alertTitle: "Короткий пароль", alertMessage: "Введите снова")
        }
    }
    
    private func passwordIsValid(password: String) -> Bool {
        return password.characters.count > 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Constants.userInfoSegue:
            let destinationVC = segue.destination as! TokenInfoViewController
            destinationVC.user = sender as! User
        default:
            break
        }
    }
}
