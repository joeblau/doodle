//
//  RatingManager.swift
//  Doodle
//
//  Created by Joe Blau on 4/16/20.
//  Copyright © 2020 Joe Blau. All rights reserved.
//

import Foundation
import StoreKit

final class RatingManager {
    static let kOpenCount = "application_open_count"
    
    init() {
        let openCount = UserDefaults.standard.integer(forKey: RatingManager.kOpenCount)
        
        switch openCount {
        case 3, 10, 30:
            SKStoreReviewController.requestReview()
        case _ where openCount % 100 == 0:
            SKStoreReviewController.requestReview()
        default: break
        }
        
        UserDefaults.standard.set(openCount+1, forKey: RatingManager.kOpenCount)
    }
}
