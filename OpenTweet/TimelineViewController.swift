//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {

    var timeline: [Tweet]!
    private var selectedTweet: Tweet?
    
	override func viewDidLoad() {
		super.viewDidLoad()

        do {
            timeline = try Tweet.parseLocalData()
        } catch {
            assertionFailure("Unable to load timeline")
        }

        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "TweetCellView", bundle: nil), forCellReuseIdentifier: "TweetCell")
        
	}

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let dest = segue.destination as? DetailTableViewController,
               let tweet = selectedTweet {
                (dest.tweet, dest.replies) = getDetail(for: tweet)
                dest.inReplyTo = tweet.inReplyTo != nil
            }
            
        }
    }
    
    /// Will get all the info necessary for the detail view to present properly.
    /// - Parameter tweet: The selected Tweet
    /// - Returns: The tweet at the start of the conversaion
    ///     A list of replies, if the selected tweet was in reply to another tweet this will
    ///     have 1 object in it. (The selected tweet)
    func getDetail(for tweet: Tweet ) -> (Tweet, [Tweet]?) {
        // If this is a reply, find the orginal tweet.
        if let replyTo = tweet.inReplyTo,
           let originalTweet = timeline.first(where: { $0.id == replyTo }) {
            return (originalTweet, [tweet])
        } else {
            // If this is an orginal tweet find all the replies to it.
            let replies: [Tweet]?
            if let r = timeline.findReplies(to: tweet)?.sortAssending(),
               r.count > 0 {
                replies = r
            } else {
                replies = nil
            }
            return (tweet, replies)
        }
        
    }
    
    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
            
        cell.tweet = timeline[indexPath.row]
        
        return cell
        
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTweet = timeline[indexPath.row]
        self.performSegue(withIdentifier: "ShowDetail", sender: nil)
    }

}

