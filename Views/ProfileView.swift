//
//  ProfileView.swift
//  Fuji
//
//  Created by Maximilian Samne on 31.03.23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


struct ProfileView: View {
    
    @AppStorage("user_greeting") var user_greeting: String = ""
    @AppStorage("user_dial") var user_dial: String = "Yellow"
    @AppStorage("user_dialThinL") var user_dialThinL: Bool = false
    @AppStorage("user_dialThinD") var user_dialThinD: Bool = false
    @AppStorage("user_authenticated") var user_authenticated: Bool = false
    
    @EnvironmentObject var networkModel: NetworkModel
    
    @Binding var treesFunded: Int
    
    @State private var walkingOut: Bool = false
    
    @FocusState var greetingFocused: Bool
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    Text("Fuji for you,")
                        .font(.system(.title2, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
                    TextField("set greeting", text: $user_greeting)
                        .underline()
                        .font(.system(.title2, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
#if os(iOS)
                        .frame(width: 140)
#elseif os(macOS)
                        .frame(width: 100)
#endif
                        .focused($greetingFocused)
                        .onChange(of: user_greeting) { _ in
                            limitGreetingText(40)
                        }
                    
                    if !networkModel.connected {
                        Spacer()
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(.callout, design: .rounded, weight: .regular))
                            .foregroundColor(Color("Gray"))
                    }
                    
                }
                .font(.system(.title2, design: .rounded, weight: .regular))
                .padding(.vertical, 10)
                .padding([.horizontal], 25)
                
                HStack {
                    Text("Lifetime stats")
                    Text("this device")
                        .foregroundColor(Color("Background"))
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .background {
                            Capsule()
                                .fill(Color("Contrast"))
                        }
                }
                .font(.system(.body, design: .rounded, weight: .regular))
                .padding(.horizontal, 25)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        ProfileAnalytics()
                        
                        HStack(alignment: .top) {
                            if user_authenticated {
                                Text("Since you joined:")
                                    .font(.system(.body, design: .rounded, weight: .light))
                            } else {
                                Text("Since you joined:\nPlease sign in to see impact 😊")
                                    .font(.system(.body, design: .rounded, weight: .light))
                            }
                            
                            if user_authenticated {
                                VStack(spacing: 10) {
                                    (Text("\(treesFunded) ")
                                        .fontWeight(.semibold)
                                     +
                                     Text("🌳 planted")
                                    )
                                    .font(.system(.callout, design: .rounded, weight: .light))
                                    .frame(width: 200, alignment: .leading)
                                    
                                    
                                    
                                    let landReforested = Double(treesFunded)*1.5
                                    (Text("\(landReforested, specifier: "%.0f")m2 ")
                                        .fontWeight(.semibold)
                                     +
                                     Text("🌍 reforested")
                                    )
                                    .font(.system(.callout, design: .rounded, weight: .light))
                                    .frame(width: 200, alignment: .leading)
                                    
                                    
                                    
                                    let marineHabitatCreated = Double(treesFunded)*0.4
                                    (Text("\(marineHabitatCreated, specifier: "%.0f")m2 ")
                                        .fontWeight(.semibold)
                                     +
                                     Text("🐠 habitat created ")
                                    )
                                    .font(.system(.callout, design: .rounded, weight: .light))
                                    .frame(width: 200, alignment: .leading)
                                    
                                }
                                .foregroundColor(Color("Contrast"))
                                .frame(width: 200, alignment: .leading)
                            }
                        }
                        .foregroundColor(Color("Contrast"))
                        .padding(.bottom, 20)
                        
                        ProfileSettings()
                        
                        ProfilePaths()
                        
                    }
                    .padding(25)
                }
            }
            .onAppear {
                greetingFocused = false
            }
        }
        .task {
            if user_authenticated {
                guard treesFunded == 0 else { return }
                getAppTreeInfo()
            }
        }
    }
    
    
    func getAppTreeInfo() {
        Task {
            let docRef = Firestore.firestore().collection("AppInfo").document("Info")
            
            docRef.getDocument { document, error in
                if error == nil {
                    if let document = document, document.exists {
                        let data = document.data()
                        if let data = data {
                            self.treesFunded = data["TreesFunded"] as? Int ?? 0
                        }
                    }
                } else {
                    print(error?.localizedDescription ?? "error")
                }
            }
        }
    }
    
    
    
    func limitGreetingText(_ upper: Int) {
        if user_greeting.count > upper {
            user_greeting = String(user_greeting.prefix(upper))
        }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(treesFunded: .constant(240))
            .environmentObject(NetworkModel())
    }
}
