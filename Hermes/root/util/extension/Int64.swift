//
//  Int64.swift
//  Hermes
//
//  Created by José Ruiz on 12/8/24.
//

import Foundation

extension Int64 {
    
    var formatDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd-MM-yy"
        dateFormatter.locale = Locale(identifier: "es_ES")
        return dateFormatter.string(from: date)
    }
    
    var formatShortHeadDate: String {
        let currentTime = Date().timeIntervalSince1970 * 1000
        let diff = currentTime - Double(self)
        
        let oneMinute: Double = 60 * 1000
        let oneHour: Double = 60 * oneMinute
        let oneDay: Double = 24 * oneHour
        
        let date = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        
        if diff < oneDay {
            return NSLocalizedString("today", comment: "Today message")
        } else if diff < 2 * oneDay {
            return NSLocalizedString("yesterday", comment: "Yerterday message")
        } else if diff < 7 * oneDay {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        } else if diff < 30 * oneDay {
            dateFormatter.dateFormat = "EEEE, d MMM"
            return dateFormatter.string(from: date)
        } else if diff < 365 * oneDay {
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    var formatDateTime: String {
        let currentTime = Date().timeIntervalSince1970 * 1000
                
        let date = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
