//
//  ContributionMenu.swift
//  Fuji
//
//  Created by Maximilian Samne on 09.04.23.
//

import SwiftUI
import Firebase

struct ContributionMenu: View {
    
#if os(iOS)
    var minWidth: CGFloat = UIScreen.main.bounds.size.width
    var minHeight: CGFloat = UIScreen.main.bounds.size.height
    
#elseif os(macOS)
    var minWidth: CGFloat = 800
    var minHeight: CGFloat = 700
    
#endif
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_welcomeSeen") var user_welcomeSeen: Bool = false
    @AppStorage("user_greeting") var user_greeting: String = ""
    @AppStorage("user_authenticated") var user_authenticated: Bool = false
    
    @EnvironmentObject var networkModel: NetworkModel
    
    @Binding var showDeleteAccountSheet: Bool
    @State private var isSigningOut: Bool = false
    
    
    var body: some View {
        HStack {
            if !networkModel.connected {
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(.subheadline, design: .rounded, weight: .light))
                    .foregroundColor(Color("Gray"))
                    .padding(.bottom, -24)
                    .padding(.trailing, 2)
            }
            
            Menu {
                Button {
                    user_welcomeSeen = false
                } label: {
                    Text("Welcome page")
                }
                .buttonStyle(.plain)
                
                if user_authenticated {
                    Button {
                        signOut()
                    } label: {
                        Text("Sign out")
                    }
                    .buttonStyle(.plain)
                    .disabled(!networkModel.connected || isSigningOut)
                }
                
                if user_UID != "" {
                    Button {
                        showDeleteAccountSheet = true
                    } label: {
                        Text("Delete Account")
                    }
                    .buttonStyle(.plain)
                    .disabled(!networkModel.connected || isSigningOut)
                }
            } label: {
                Image(systemName: "circle.dotted")
                    .font(.system(.title3, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    .padding(.trailing, 25)
            }
            .menuStyle(.borderlessButton)
            .frame(width: 40)
            .contentShape(Rectangle())
#if os(macOS)
            .padding(.top, 17)
#endif
        }
        .frame(width: minWidth, alignment: .trailing)
    }
    
    
    func signOut() {
        isSigningOut = true
        try? Auth.auth().signOut()
        user_greeting = ""
        user_authenticated = false
        isSigningOut = false
    }
}

struct ContributionMenu_Previews: PreviewProvider {
    static var previews: some View {
        ContributionMenu(showDeleteAccountSheet: .constant(false))
            .environmentObject(NetworkModel())
    }
}
