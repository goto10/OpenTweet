//
//  TweetTableViewCell.swift
//  OpenTweet
//
//  Created by Myke on 3/27/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var replyLineTop: UIView!
    @IBOutlet weak var replyLineBottom: UIView!
    
    fileprivate var webImage: WebImage?
    
    var tweet: Tweet! {
        didSet {
            updateCellView()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        avatarImageView.image = UIImage(named: "doge-600")
        avatarImageView.toRound()
        authorLabel.text = nil
        contentTextView.attributedText = nil
        dateLabel.text = nil
        webImage?.cancel()
        webImage = nil
        replyLineTop.isHidden = true
        replyLineBottom.isHidden = true
    }
    
    // MARK: - App Logic
    
    /// Once a Tweet has been set this will update the UI of the Cell.
    func updateCellView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        
        authorLabel.text = tweet.author
        contentTextView.attributedText = tweet.formattedContent()
        dateLabel.text = dateFormatter.string(from: tweet.date)
        avatarImageView.toRound()
        if let avatar = tweet.avatar {
            webImage = WebImage()
            webImage?.loadImage(from: avatar, completion: { image, error in
                guard let avatarImage = image, error == nil else { return }
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatarImage
                    self.avatarImageView.toRound()
                }
            })
        }
        
    }
    
}
