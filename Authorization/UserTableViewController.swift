//
//  UserTableViewController.swift
//  Authorization
//
//  Created by Akerke Okapova on 7/3/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit

private struct Constants {
    
    static let feedSegue = "ShowFeed"
}

class UserTableViewController: UITableViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userTelephoneLabel: UILabel!
    @IBOutlet weak var userCityLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func showFeed() {
        performSegue(withIdentifier: Constants.feedSegue, sender: nil)
    }
    
    @IBAction func showFeedBarButtonItem(_ sender: UIBarButtonItem) {
        showFeed()
    }
    
    @IBAction func logoutBarButtonItem(_ sender: UIBarButtonItem) {
        let url = Storage.user!.imageUrl
        Storage.user = nil
        Storage.removeImage(url: url)
        Storage.clearImageCache()
        appDelegate.loadAuthorizationPage()
    }
    
    var user = Storage.user! {
        didSet{
            updateUI()
        }
    }
    
    private func updateUI() {
        print(user)
        userNameLabel?.text = user.name
        userEmailLabel?.text = user.email
        userTelephoneLabel?.text = user.telephone
        userCityLabel?.text = user.city
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
    }
    
    private func makeImageRounded() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.size.width / 2;
        userPhotoImageView.clipsToBounds = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeImageRounded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUserInfo()
    }
    
    private func getUserInfo() {
        spinner.startAnimating()
        
        let url = Storage.user!.imageUrl
        
        Storage.getImage(url: url) { image in
            if image == nil {
                User.fetchImage(with: url) { image in
                    //Storage.addImage(image: image, url: url)
                    self.userPhotoImageView.image = image
                    self.spinner.stopAnimating()
                }
            } else {
                self.spinner.stopAnimating()
                self.userPhotoImageView.image = image!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        updateUI()
    }
}
