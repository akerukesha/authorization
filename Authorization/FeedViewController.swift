//
//  FeedViewController.swift
//  Authorization
//
//  Created by Akerke Okapova on 7/4/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit

private struct Constants {
    static let pollCellIdentifier = "PollCell"
    
    static let defaultPhoto = #imageLiteral(resourceName: "avatar")
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var polls: [Poll] = []
    
    @IBAction func logoutBarButtonItem(_ sender: Any) {
        let url = Storage.user!.imageUrl
        Storage.user = nil
        Storage.removeImage(url: url)
        Storage.clearImageCache()
        appDelegate.loadAuthorizationPage()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(polls.count)
        return polls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: Constants.pollCellIdentifier, for: indexPath) as! PollTableViewCell
        cell.poll = polls[indexPath.row]
        
        return cell
    }
    
    private func configureTableView() {
        feedTableView.estimatedRowHeight = 200
        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        getPolls()
    }
    
    private func getPolls() {
        
        Poll.getPolls() { results, message in
            
            if let message = message {
                
                self.showAlert(alertTitle: "Произошла ошибка", alertMessage: message)
            } else {
                
                self.polls = results!
                self.feedTableView.reloadData()
            }
        }
    }
}
