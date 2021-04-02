//
//  DetailTableViewController.swift
//  OpenTweet
//
//  Created by Myke on 4/1/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var tweet: Tweet!
    var replies: [Tweet]?
    var inReplyTo: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "TweetCellView", bundle: nil), forCellReuseIdentifier: "TweetCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 1
        if replies != nil { sections += 1 }
        
        return sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return replies?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let count = replies?.count else { return nil }
        
        if section == 0 && !inReplyTo {
            return "\(count) \(count == 1 ? "reply" : "replies")"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
        if indexPath.section == 0 {
            cell.tweet = tweet
            if inReplyTo {
                cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: .greatestFiniteMagnitude)
                cell.replyLineBottom.isHidden = false
            }
        } else {
            if let reply = replies?[indexPath.row] {
                cell.tweet = reply
                if inReplyTo {
                    cell.replyLineTop.isHidden = false
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
