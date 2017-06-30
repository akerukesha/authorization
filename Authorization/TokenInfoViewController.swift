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
    var user = Storage.user! {
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var tokenTextLabel: UILabel!
    
    @IBAction func logout(_ sender: UIButton) {
    
        //User.deleteFromStorage()
        Storage.user = nil
        appDelegate.loadAuthorizationPage()
    }
    
    private func updateUI() {
        
        tokenTextLabel?.text = user.toJSONString()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        updateUI()
    }
}
