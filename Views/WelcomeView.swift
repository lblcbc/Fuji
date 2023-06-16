//
//  WelcomeView.swift
//  Fuji
//
//  Created by Maximilian Samne on 08.04.23.
//

import SwiftUI
import RevenueCat

struct WelcomeView: View {
    
#if os(iOS)
    var circleWidth: CGFloat = UIScreen.main.bounds.size.height*0.47
    var minWidth: CGFloat = UIScreen.main.bounds.size.width
    var minHeight: CGFloat = UIScreen.main.bounds.size.height
    
#elseif os(macOS)
    var circleWidth: CGFloat = 500
    var minWidth: CGFloat = 800
    var minHeight: CGFloat = 680
    
#endif
    
    @AppStorage("user_welcomeSeen") var user_welcomeSeen: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    @EnvironmentObject var networkModel: NetworkModel
    @State private var isRestoring: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome to Fuji")
                    .font(.system(.largeTitle, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                
                Spacer()
                
                ZStack {
                    if colorScheme == .light {
                        Circle()
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow1"), Color("Yellow2"), Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3")]), center: .center))
                            .rotationEffect(.degrees(180))
                            .frame(width: circleWidth+10, height: circleWidth+10)
                            .blur(radius: 41)
                    } else {
                        Circle()
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow1"), Color("Yellow2"), Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3")]), center: .center))
                            .rotationEffect(.degrees(180))
                            .frame(width: circleWidth, height: circleWidth)
                            .blur(radius: 41)
                    }
                    
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: circleWidth-100, height: circleWidth-100)
                    
                    if !isRestoring {
                        Text("A new focus.")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundColor(Color("Contrast"))
                    } else {
                        Text("Initiating...")
                            .font(.system(.headline, design: .rounded, weight: .regular))
                            .foregroundColor(Color("Contrast"))
                    }
                }
                
                Spacer()
                
                Button {
                    if networkModel.connected {
                        isRestoring = true
                        Purchases.shared.restorePurchases { customerInfo, error in
                            if (customerInfo?.entitlements.all["All Access"]?.isActive == true) == true {
                                userSubscriptionModel.userSubscribed = true
                                user_welcomeSeen = true
                            } else {
                                userSubscriptionModel.userSubscribed = false
                                errorMessage = "No active account found, but you can activate one in seconds 🙌"
                                showError = true
                                isRestoring = false
                            }
                        }
                    } else {
                        errorMessage = "To continue, please connect to a network 🫧"
                        showError = true
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Already joined")
                            .font(.system(.headline, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(.footnote, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                        
                    }
                    .padding(.leading, 6)
                    .padding(.vertical, 5)
                }
#if os(macOS)
                .buttonStyle(.plain)
#endif
                .contentShape(Rectangle())
                
                
                Button {
                    user_welcomeSeen = true
                } label: {
                    Text("Join Fuji")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundColor(Color("Background"))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .background {
                            Capsule()
                                .fill(Color("Contrast"))
                        }
                }
#if os(macOS)
                .buttonStyle(.plain)
#endif
                .contentShape(Rectangle())
            }
            .padding(25)
#if os(iOS)
            .frame(width: minWidth)
#elseif os(macOS)
            .frame(minWidth: minWidth, minHeight: minHeight)
#endif
        }
        .sheet(isPresented: $showError) {
            VStack {
                Text("\(errorMessage)")
                    .font(.system(.body, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                
                Spacer()
                
                Button {
                    user_welcomeSeen = true
                } label: {
                    Text("Join Fuji")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundColor(Color("Background"))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .background {
                            Capsule()
                                .fill(Color("Contrast"))
                        }
                }
                .buttonStyle(.plain)
                
            }
            .padding(25)
            .presentationDetents([.height(minHeight*0.24)])
        }
        .disabled(isRestoring)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
