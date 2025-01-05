//
//  formatDate.swift
//  Hermes
//
//  Created by José Ruiz on 2/8/24.
//

import Foundation

func formatDate(date: Int64) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(date) / 1000)
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: date)
}
