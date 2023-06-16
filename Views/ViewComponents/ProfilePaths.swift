//
//  ProfilePaths.swift
//  Fuji
//
//  Created by Maximilian Samne on 01.04.23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import RevenueCat

struct ProfilePaths: View {
    
    @AppStorage("user_greeting") var user_greeting: String = ""
    @AppStorage("original_time") var original_time: Double = 1200
    @AppStorage("time_remaining") var time_remaining: Double = 1200
    @AppStorage("user_authenticated") var user_authenticated: Bool = false
    @AppStorage("user_dialThinL") var user_dialThinL: Bool = false
    @AppStorage("user_dialThinD") var user_dialThinD: Bool = false
    
    @EnvironmentObject var networkModel: NetworkModel
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    @State private var isSigningOut: Bool = false
    @State private var showDeleteAccountSheet: Bool = false
    @State private var showRestoreCheckmark: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Button {
                    signOut()
                } label: {
                    Text("Sign out")
                        .font(.system(.body, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
                        .padding(4)
                }
                .buttonStyle(.plain)
                .disabled(!networkModel.connected || isSigningOut || !user_authenticated)
                
                if !networkModel.connected {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(.footnote, design: .rounded, weight: .light))
                        .foregroundColor(Color("Gray"))
                        .padding(4)
                }
                
                if !user_authenticated {
                    Image(systemName: "checkmark")
                        .font(.system(.footnote, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
                        .padding(4)
                        .padding(.top, 2)
                }
            }
            
            HStack(alignment: .top) {
                Button {
                    showDeleteAccountSheet = true
                } label: {
                    Text("Delete account")
                        .font(.system(.body, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
                        .padding(4)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 40)
                .disabled(!networkModel.connected || isSigningOut)
                
                if !networkModel.connected {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(.footnote, design: .rounded, weight: .light))
                        .foregroundColor(Color("Gray"))
                        .padding(4)
                }
                
            }
            
            Link("Terms of use", destination: URL(string: "https://docs.google.com/document/d/1OAb-BmdyCu7aoVyun9NYYWEfU94oYkiLIiKTSmOSBCQ/edit?usp=sharing")!)
                .font(.system(.body, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                .padding(4)
                .disabled(isSigningOut || !networkModel.connected)
            
            Link("Privacy policy", destination: URL(string: "https://docs.google.com/document/d/1OAb-BmdyCu7aoVyun9NYYWEfU94oYkiLIiKTSmOSBCQ/edit?usp=sharing")!)
                .font(.system(.body, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                .padding(4)
                .disabled(isSigningOut || !networkModel.connected)
        }
        .sheet(isPresented: $showDeleteAccountSheet) {
            DeleteAccountSheet(showDeleteAccountSheet: $showDeleteAccountSheet)
        }
    }
    
    
    func signOut() {
        isSigningOut = true
        try? Auth.auth().signOut()
        user_greeting = ""
        original_time = 1200
        time_remaining = 1200
        user_authenticated = false
        user_dialThinL = false
        user_dialThinD = false
        isSigningOut = false
    }
    
}

struct ProfilePaths_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePaths()
            .environmentObject(NetworkModel())
    }
}
