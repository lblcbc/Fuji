//
//  ContentView.swift
//  Fuji
//
//  Created by Maximilian Samne on 20.03.23.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_greeting") var user_greeting: String = ""
    @AppStorage("user_dial") var user_dial: String = "Yellow"
    @AppStorage("original_time") var original_time: Double = 1200
    @AppStorage("user_tasksCompleted") var user_tasksCompleted: Int = 0
    @AppStorage("user_authenticated") var user_authenticated: Bool = false
    @AppStorage("user_welcomeSeen") var user_welcomeSeen: Bool = false
    @AppStorage("user_dialThinL") var user_dialThinL: Bool = false
    @AppStorage("user_dialThinD") var user_dialThinD: Bool = false
    
    
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    
    @StateObject var networkModel = NetworkModel()
    
    @State private var isChecking: Bool = true
    @State private var isAnimated: Bool = false
    
    
    var body: some View {
        if !isChecking {
            ZStack {
                if user_welcomeSeen {
                    if userSubscriptionModel.userSubscribed {
                        HomeView()
                            .environmentObject(networkModel)
                    } else {
                        ContributionView()
                            .environmentObject(networkModel)
                    }
                } else {
                    WelcomeView()
                        .environmentObject(networkModel)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: user_welcomeSeen)
        } else {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
            }
            .onAppear {
                checkMargin()
            }
        }
    }
    
    func checkMargin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if user_UID != "" {
                Firestore.firestore().collection("Users").document(user_UID).getDocument { document, error in
                    if let document = document, document.exists {
                        print("User document exists")
                        isChecking = false
                    } else {
                        print("User document does NOT exist")
                        user_welcomeSeen = false
                        user_authenticated = false
                        user_greeting = ""
                        user_dial = "Yellow"
                        original_time = 1200
                        user_dialThinL = false
                        user_dialThinD = false
                        isChecking = false
                    }
                }
            } else {
                isChecking = false
            }
        }
    }
    
    
}
