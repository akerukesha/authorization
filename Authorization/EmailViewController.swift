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
    static let enabledColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
    static let disabledColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
}

extension UIViewController {
    
    func showAlert(alertTitle: String, alertMessage: String) {
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alertView, animated:true, completion:nil)
    }
}

class EmailViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailTextFieldBottom: UIView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
        //переделать:
        //удалить кнопку, заново создать
        if let text = emailTextField.text, text.isEmpty == false{
            navBar.rightBarButtonItem = UIBarButtonItem.init(title: "Далее", style: .done, target: self, action: #selector(EmailViewController.showPassword))
        } else {
            navBar.rightBarButtonItem = nil
        }
    }
    
    @IBAction func emailTextFieldActivated(_ sender: UITextField) {
        emailTextFieldBottom.backgroundColor = Constants.enabledColor
    }
    @IBAction func emailTextFieldDeactivated(_ sender: UITextField) {
        emailTextFieldBottom.backgroundColor = Constants.disabledColor
    }

    @objc func showPassword(){
        let email = emailTextField.text!
        //email validation
        if emailIsValid(email: email) {
            performSegue(withIdentifier: Constants.PasswordSegue, sender: email)
        } else {
            showAlert(alertTitle: "Неправильный email", alertMessage: "Введите снова")
        }
    }
    
    private func emailIsValid(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier!{
        case Constants.PasswordSegue:
            let destinationVC = segue.destination as! PasswordViewController
            destinationVC.email = sender as! String
        default:
            break
        }
    }
}
