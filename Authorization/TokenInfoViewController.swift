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
        updateUI()
    }
}
