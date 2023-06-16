//
//  SignInView.swift
//  Fuji
//
//  Created by Maximilian Samne on 20.03.23.
//

import SwiftUI
import AuthenticationServices
import Firebase
import FirebaseFirestoreSwift

struct SignInView: View {
    
#if os(iOS)
    var circleWidth: CGFloat = UIScreen.main.bounds.size.height*0.47
    var minWidth: CGFloat = UIScreen.main.bounds.size.width
    var minHeight: CGFloat = UIScreen.main.bounds.size.height
    
#elseif os(macOS)
    var circleWidth: CGFloat = 345
    var minWidth: CGFloat = 500
    var minHeight: CGFloat = 700
    
#endif
    
    @AppStorage("user_UID") var user_UID: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("user_greeting") var user_greeting: String = ""
    
    @EnvironmentObject var networkModel: NetworkModel
    
    @StateObject var loginData = SignInWithApple()
    
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var isSigningIn: Bool = false
    @State private var fetching: Bool = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack(spacing: 0) {
#if os(iOS)
                let currentHour = Calendar.current.dateComponents([.hour], from: Date()).hour
                HStack {
                    if user_greeting != "" {
                        if currentHour! < 12 {
                            Text("Good morning, \(user_greeting).")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        } else if currentHour! >= 12 {
                            Text("Good evening, \(user_greeting).")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        } else {
                            Text("Hello, \(user_greeting).")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        }
                    } else {
                        if currentHour! < 12 {
                            Text("Good morning.")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        } else if currentHour! >= 12 {
                            Text("Good evening.")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        } else {
                            Text("Hello.")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        }
                    }
                }
                .padding(.bottom, 10)
#endif
                
#if os(iOS)
                if minHeight < 700 {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .shadow(color: Color("Shadow"), radius: 5, y: 3)
                        
                        Text("Beauty in simplicity")
                            .font(.system(.title3, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                            .padding(.leading, 25)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 25)
                    .frame(width: UIScreen.main.bounds.size.width, height: 140, alignment: .topLeading)
                    .padding(.bottom, 10)
                    
                } else if minHeight > 700 && minHeight < 840 {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .shadow(color: Color("Shadow"), radius: 5, y: 3)
                        
                        Text("Beauty in simplicity")
                            .font(.system(.title3, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                            .padding(.leading, 25)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 25)
                    .frame(width: UIScreen.main.bounds.size.width, height: 148, alignment: .topLeading)
                    .padding(.bottom, 10)
                    
                } else if minHeight > 840 && minHeight < 870 {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .shadow(color: Color("Shadow"), radius: 5, y: 3)
                        
                        Text("Beauty in simplicity")
                            .font(.system(.title3, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                            .padding(.leading, 25)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 25)
                    .frame(width: UIScreen.main.bounds.size.width, height: 154, alignment: .topLeading)
                    .padding(.bottom, 10)
                } else {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .shadow(color: Color("Shadow"), radius: 5, y: 3)
                        
                        Text("Beauty in simplicity")
                            .font(.system(.title3, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                            .padding(.leading, 25)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 25)
                    .frame(width: UIScreen.main.bounds.size.width, height: 170, alignment: .topLeading)
                    .padding(.bottom, 10)
                }
                
#elseif os(macOS)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .foregroundColor(Color("Background"))
                        .shadow(color: Color("Shadow"), radius: 5, y: 3)
                    
                    Text("Beauty in simplicity")
                        .font(.system(.title3, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
                        .padding(.leading, 25)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 25)
                .frame(width: 320, height: 130, alignment: .topLeading)
                .frame(width: minWidth, alignment: .leading)
                .padding(.bottom, 20)
                
#endif
                
                SignInInfo()
                Spacer()
                
                if networkModel.connected {
                    if colorScheme == .light {
                        SignInWithAppleButton { (request) in
                            // requesting paramertes from apple login...
                            isSigningIn = true
                            loginData.nonce = randomNonceString()
                            request.nonce = sha256(loginData.nonce)
                            
                        } onCompletion: { (result) in
                            // getting error or success...
                            switch result {
                            case .success(let user):
                                print("Case: Success")
                                // do Login With Firebase...
                                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                    print("error with firebase")
                                    return
                                }
                                loginData.authenticate(credential: credential)
                                
                            case.failure(_):
                                isSigningIn = false
                            }
                        }
                        .signInWithAppleButtonStyle(.black)
                        .frame(width: 200, height: 40)
#if os(iOS)
                        .clipShape(Capsule())
#endif
                        .disabled(isSigningIn)
                        
                    } else {
                        SignInWithAppleButton { (request) in
                            isSigningIn = true
                            loginData.nonce = randomNonceString()
                            request.nonce = sha256(loginData.nonce)
                            
                        } onCompletion: { (result) in
                            switch result {
                            case .success(let user):
                                print("Case: Success")
                                // do Login With Firebase...
                                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                    print("error with firebase")
                                    return
                                }
                                loginData.authenticate(credential: credential)
                                
                            case.failure(_):
                                isSigningIn = false
                            }
                        }
                        .signInWithAppleButtonStyle(.white)
                        .frame(width: 200, height: 40)
#if os(iOS)
                        .clipShape(Capsule())
#endif
                        .disabled(isSigningIn)
                    }
                } else {
                    Text("Connect to a network to continue 🫧")
                        .font(.system(.body, design: .rounded, weight: .regular))
                        .multilineTextAlignment(.center)
#if os(macOS)
                        .padding(.horizontal, 29)
                        .frame(width: minWidth, alignment: .leading)
#endif
                    
                    Spacer()
                        .frame(height: 25)
                }
                
                
                if networkModel.connected {
                    HStack(spacing: 0) {
                        if !isSigningIn {
                            Text("Our ")
                                .font(.system(.footnote, design: .rounded, weight: .light))
                            
                            Link("terms of use", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                                .font(.system(.footnote, design: .rounded, weight: .medium))
                            
                            Text(" and ")
                                .font(.system(.footnote, design: .rounded, weight: .light))
                            
                            Link("privacy policy", destination: URL(string: "https://docs.google.com/document/d/1OAb-BmdyCu7aoVyun9NYYWEfU94oYkiLIiKTSmOSBCQ/edit?usp=sharing")!)
                                .font(.system(.footnote, design: .rounded, weight: .medium))
                            
                            Text(".")
                                .font(.system(.footnote, design: .rounded, weight: .light))
                        } else {
                            Text("Signing in...")
                                .font(.system(.footnote, design: .rounded, weight: .medium))
                        }
                        
                    }
                    .foregroundColor(Color("Gray"))
                    .frame(height: 29, alignment: .bottom)
#if os(macOS)
                    .padding(.bottom, 25)
#endif
                }
                
            }
            .padding(.top, 25)
#if os(iOS)
            .frame(width: minWidth)
#elseif os(macOS)
            .frame(minWidth: minWidth, minHeight: minHeight)
#endif
            .ignoresSafeArea(.keyboard)
            .animation(.linear(duration: 0.5), value: colorScheme)
            
        }
        .disabled(isSigningIn)
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NetworkModel())
    }
}
