//
//  StoreStatusDto.swift
//  Hermes
//
//  Created by José Ruiz on 22/6/24.
//

import Foundation

struct StatusDto: Codable {
    var isActive: Bool = true
    var isVerified: Bool = true
    var isPromoted: Bool = false
    var isSuspended: Bool = false
    var isClosed: Bool = false
    var isPendingApproval: Bool = false
    var isUnderReview: Bool = false
    var isOutOfStock: Bool = false
    var isOnSale: Bool = false
    
    func toStatus() -> Status {
        return Status(isActive: isActive,
                      isVerified: isVerified,
                      isPromoted: isPromoted,
                      isSuspended: isSuspended,
                      isClosed: isClosed,
                      isPendingApproval: isPendingApproval,
                      isUnderReview: isUnderReview,
                      isOutOfStock: isOutOfStock,
                      isOnSale: isOnSale)
    }
}
