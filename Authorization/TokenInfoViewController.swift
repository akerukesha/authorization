//
//  TokenInfoViewController.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/22/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit

class TokenInfoViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user: User!{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var tokenTextLabel: UILabel!
    
    @IBAction func logout(_ sender: UIButton) {
    
        User.deleteFromStorage()
        appDelegate.switchStoryboard("login")
    }
    
    private func updateUI() {
        
        tokenTextLabel?.text = user.token
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let currentUser = self.appDelegate.getUser() {
            user = currentUser
        }
        updateUI()
    }
}
