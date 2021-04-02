//
//  UIImage+OpenTweet.swift
//  OpenTweet
//
//  Created by Myke on 4/1/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func toRound() {
        let radius = max(frame.width, frame.height) / 2
        layer.cornerRadius = radius
    }
    
}
