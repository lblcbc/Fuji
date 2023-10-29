//
//  FujiApp.swift
//  Fuji
//
//  Created by Maximilian Samne on 20.03.23.
//

import SwiftUI
import Firebase
import RevenueCat

@main
struct FujiApp: App {
    
    
    @StateObject var userSubscriptionModel = UserSubscriptionModel()
    
    
    init() {
        FirebaseApp.configure()
        
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        let db = Firestore.firestore()
        db.settings = settings
        
        
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "XXXXXXXXXXX") // <-- replace with your RevenueCat API key
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSubscriptionModel)
        }
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
