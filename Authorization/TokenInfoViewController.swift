//
//  TokenInfoViewController.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/22/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit

class TokenInfoViewController: UIViewController {

    @IBOutlet weak var tokenTextLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var user: User!{
        didSet{
            updateUI()
        }
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
