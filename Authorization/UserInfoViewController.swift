//
//  UserInfoViewController.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/27/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var user = Storage.user! {
        didSet{
            updateUI()
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let url = Storage.user!.imageUrl
        Storage.user = nil
        Storage.removeImage(url: url)
        appDelegate.loadAuthorizationPage()
    }

    private func updateUI() {
        
        userName?.text = user.name
        userEmail?.text = user.email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    private func makeImageRounded() {
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width / 2;
        userPhoto.clipsToBounds = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeImageRounded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        spinner.startAnimating()
        
        let url = Storage.user!.imageUrl
        
        Storage.getImage(url: url) { image in
            if image == nil {
                User.fetchImage(with: url) { image in
                    self.userPhoto.image = image
                    self.spinner.stopAnimating()
                }
            } else {
                self.spinner.stopAnimating()
                self.userPhoto.image = image!
            }
        }
    }
}
