//
//  Timeline.swift
//  OpenTweet
//
//  Created by Myke on 3/26/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

struct Tweet: Codable {
    let id: String
    let author: String
    let avatar: String?
    let content: String
    let inReplyTo: String?
    let date: Date
}

struct Timeline: Codable {
    let timeline: [Tweet]
}

extension Array where Element == Tweet {
    
    func sortAssending() -> [Tweet] {
        return sorted(by: { $0.date.compare($1.date) == .orderedAscending })
    }
    
    func findReplies(to tweet: Tweet) -> [Tweet]? {
        return filter { t -> Bool in
            t.inReplyTo == tweet.id
        }
    }
}

extension Tweet {
    
    /// Loads the timeline data from the app package.
    /// - Throws: When unable to load the data from the app package or decoding the json.
    /// - Returns: An array of tweets ordered as they were in the json file.
    static func parseLocalData() throws -> [Tweet] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let dataPath = Bundle.main.path(forResource: "timeline", ofType: "json") else {
            let e = NSError(domain: "Data Loading", code: 100, userInfo: ["description":"Error loading JSON file"])
            throw e
        }
        
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: dataPath))
            let timeline = try decoder.decode(Timeline.self, from: jsonData).timeline
            return timeline
        } catch {
            print(error)
            throw error
        }
    }
        
    /// Returns the tweet content as an AttributedString with any usernames highlited.
    /// Usernames are defined as any string preceded by '@'
    /// - Returns: NSAttributedString with highlihted usernames.
    func formattedContent() -> NSAttributedString {
        let formattedText = NSMutableAttributedString(string: content)
        let range = NSRange(location: 0, length: formattedText.length)
        let regex = try! NSRegularExpression(pattern: "@([^\\s]+)", options: NSRegularExpression.Options.caseInsensitive)
        
        let matches = regex.matches(in: content, options: [], range: range)
        
        for match in matches {
            formattedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "mention")!, range: match.range)
        }
        
        return formattedText
    }
    
}
