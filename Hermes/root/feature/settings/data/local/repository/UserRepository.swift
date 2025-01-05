//
//  UserRepository.swift
//  Hermes
//
//  Created by José Ruiz on 18/7/24.
//

import Foundation
import SwiftData

//class UserRepository: UserRepositoriable {
//    private var modelContext: ModelContext
//    
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//    }
//    
//    func createOrUpdateUser(user: UserEntity) {
//        do {
//            var fetchRequest = FetchDescriptor<UserEntity>(sortBy: [SortDescriptor(\.id)])
//            fetchRequest.fetchLimit = 1
//            let existingUsers = try modelContext.fetch(fetchRequest)
//            
//            if let existingUser = existingUsers.first {
//                existingUser.name = user.name
//                existingUser.location = user.location
//                print("User updated")
//            } else {
//                self.modelContext.insert(user)
//                print("User created")
//            }
//            try modelContext.save()
//        } catch {
//            print("Failed to create or update user: \(error.localizedDescription)")
//        }
//    }
//    
//    func updateUserLocation(add: Bool, location: UserLocation) {
//        do {
//            var fetchRequest = FetchDescriptor<UserEntity>(sortBy: [SortDescriptor(\.id)])
//            fetchRequest.fetchLimit = 1
//            let existingUsers = try modelContext.fetch(fetchRequest)
//            
//            
//        } catch {
//            print("Failed to update user location: \(error.localizedDescription)")
//        }
//    }
//    
//    func makeDefaultUserLocation(location: UserLocation) {
//        do {
//            var fetchRequest = FetchDescriptor<UserEntity>(sortBy: [SortDescriptor(\.id)])
//            fetchRequest.fetchLimit = 1
//            let existingUsers = try modelContext.fetch(fetchRequest)
//            
//            if let existingUser = existingUsers.first {
//                
//                
//                try modelContext.save()
//            }
//        } catch {
//            print("Failed to update user location: \(error.localizedDescription)")
//        }
//    }
//    
//    func fetchUser() -> UserEntity? {
//        do {
//            var fetchRequest = FetchDescriptor<UserEntity>(sortBy: [SortDescriptor(\.id)])
//            fetchRequest.fetchLimit = 1
//            
//            let existingUsers = try modelContext.fetch(fetchRequest)
//            return existingUsers.first
//        } catch {
//            print("Failed to fetch user: \(error.localizedDescription)")
//            return nil
//        }
//    }
//}
