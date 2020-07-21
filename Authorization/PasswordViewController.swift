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
    
    static let tokenInfoSegue = "ShowToken"
    static let userInfoSegue = "ShowUser"
    static let userProfileSegue = "ShowUserProfile"
}

class PasswordViewController: UIViewController, NVActivityIndicatorViewable {

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
    
    func authorize() {
        
        let password = passwordTextField.text!
        
        if User.passwordIsValid(password: password) == true {
            
            self.dismissKeyboard()
            startAnimating()
            User.authorize(email: email, password: password) { user, message in
    
                self.stopAnimating()
                if let message = message {
                    
                    self.showAlert(alertTitle: "Произошла ошибка", alertMessage: message)
                } else {
                    Storage.user = user
//                    print(user ?? "no user")
                    self.performSegue(withIdentifier: Constants.userProfileSegue, sender: user!)
                }
            }
        } else {
            
            showAlert(alertTitle: "Короткий пароль", alertMessage: "Введите снова")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case Constants.userProfileSegue:
            let destinationVC = segue.destination as! UINavigationController
            let currentVC = destinationVC.topViewController as! UserTableViewController
            currentVC.user = sender as! User
        case Constants.userInfoSegue:
            let destinationVC = segue.destination as! UserInfoViewController
            destinationVC.user = sender as! User
        case Constants.tokenInfoSegue:
            let destinationVC = segue.destination as! TokenInfoViewController
            destinationVC.user = sender as! User
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        passwordTextField.becomeFirstResponder()
        passwordNavBar.rightBarButtonItem = nil
        //self.hideKeyboardWhenTappedAround()
        passwordTextField.delegate = self as UITextFieldDelegate
        passwordTextField.returnKeyType = UIReturnKeyType.next
    }
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        authorize()
        return true
    }
}
