//
//  EmailViewController.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/21/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit

private struct Constants {
    
    static let PasswordSegue = "ShowPassword"
}

extension UIViewController {
    
    static let enabledColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
    static let disabledColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func showAlert(alertTitle: String, alertMessage: String) {
        
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alertView, animated:true, completion:nil)
    }
}

class EmailViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextFieldBottom: UIView!
    @IBOutlet weak var emailNavBar: UINavigationItem!
    
    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
        
        if let text = emailTextField.text, text.isEmpty == false{
            emailNavBar.rightBarButtonItem = UIBarButtonItem.init(title: "Далее", style: .done, target: self, action: #selector(EmailViewController.showPassword))
        } else {
            emailNavBar.rightBarButtonItem = nil
        }
    }
    
    @IBAction func emailTextFieldActivated(_ sender: UITextField) {
        
        emailTextFieldBottom.backgroundColor = UIViewController.enabledColor
    }
    
    @IBAction func emailTextFieldDeactivated(_ sender: UITextField) {
        
        emailTextFieldBottom.backgroundColor = UIViewController.disabledColor
    }

    @objc func showPassword(){
        
        let email = emailTextField.text!
        
        //email validation
        if User.emailIsValid(email: email) {
            
            self.dismissKeyboard()
            performSegue(withIdentifier: Constants.PasswordSegue, sender: email)
        } else {
            
            showAlert(alertTitle: "Неправильный email", alertMessage: "Введите снова")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier!{
        case Constants.PasswordSegue:
            let destinationVC = segue.destination as! PasswordViewController
            destinationVC.email = sender as! String
            let backButton = UIBarButtonItem()
            backButton.title = "Назад"
            navigationItem.backBarButtonItem = backButton
        default:
            break
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        emailNavBar.rightBarButtonItem = nil
        //self.hideKeyboardWhenTappedAround()
        emailTextField.delegate = self as UITextFieldDelegate
    }
}

extension EmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        showPassword()
        return true
    }
}
