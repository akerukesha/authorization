//
//  PasswordViewController.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/21/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

private struct Constants {
    static let userInfoSegue = "ShowToken"
}

class PasswordViewController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {

    var email: String!

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordTextFieldBottom: UIView!
    
    @IBOutlet weak var passwordNavBar: UINavigationItem!
    
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        if let text = passwordTextField.text, text.isEmpty == false{
            passwordNavBar.rightBarButtonItem = UIBarButtonItem.init(title: "Далее", style: .done, target: self, action: #selector(PasswordViewController.authorize))
        } else {
            passwordNavBar.rightBarButtonItem = nil
        }
    }
    
    @IBAction func passwordTextFieldActivated(_ sender: UITextField) {
        passwordTextFieldBottom.backgroundColor = UIViewController.enabledColor
    }
    
    @IBAction func passwordTextFieldDeactivated(_ sender: UITextField) {
        passwordTextFieldBottom.backgroundColor = UIViewController.disabledColor
    }
    
    @objc func authorize() {
        let password = passwordTextField.text!
        
        if passwordIsValid(password: password) == true {
            
            self.dismissKeyboard()
            startAnimating()
            User.authorize(email: email, password: password) { user, message in
                
                self.stopAnimating()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordNavBar.rightBarButtonItem = nil
        self.hideKeyboardWhenTappedAround()
        self.passwordTextField.delegate = self as UITextFieldDelegate
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        authorize()
        return true
    }
}
