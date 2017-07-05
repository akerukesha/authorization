//
//  PollTableViewCell.swift
//  Authorization
//
//  Created by Akerke Okapova on 7/4/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit

class PollTableViewCell: UITableViewCell {

    @IBOutlet weak var pollImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var poll: Poll! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        titleLabel.text = poll!.title
        pollImageView.image = nil
        
        getImage()
    }
    
    private func setImage(image: UIImage) {
        pollImageView.image = image
    }
    
    private func getImage() {
        spinner.startAnimating()
        
        let url = poll.imageUrl
        
        Storage.getImage(url: url) { image in
            if image == nil {
                User.fetchImage(with: url) { image in
                    
                    if let currentImage = image {
                        self.setImage(image: currentImage)
                    } else {
                        self.pollImageView.image = nil
                    }
                    self.spinner.stopAnimating()
                }
            } else {
                self.setImage(image: image!)
                self.spinner.stopAnimating()
            }
        }
    }
}
