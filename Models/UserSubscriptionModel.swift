//
//  UserSubscriptionModel.swift
//  Fuji
//
//  Created by Maximilian Samne on 20.03.23.
//

import Foundation
import SwiftUI
import RevenueCat


class UserSubscriptionModel: ObservableObject {
    @Published var userSubscribed = false
    
    init() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if error == nil {
                self.userSubscribed = customerInfo?.entitlements.all["All Access"]?.isActive == true
            } else {
                self.userSubscribed = false
            }
        }
    }
}
