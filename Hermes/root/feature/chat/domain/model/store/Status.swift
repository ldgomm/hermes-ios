//
//  StoreStatus.swift
//  Maia
//
//  Created by José Ruiz on 22/6/24.
//

import Foundation

struct Status {
    var isActive: Bool
    var isVerified: Bool
    var isPromoted: Bool
    var isSuspended: Bool
    var isClosed: Bool
    var isPendingApproval: Bool
    var isUnderReview: Bool
    var isOutOfStock: Bool
    var isOnSale: Bool
    
    func toStatusDto() -> StatusDto {
        return StatusDto(isActive: isActive,
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
