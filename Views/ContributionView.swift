//
//  ContributionView.swift
//  Fuji
//
//  Created by Maximilian Samne on 20.03.23.
//

import SwiftUI
import RevenueCat
import Firebase
import AuthenticationServices

struct ContributionView: View {
    
#if os(iOS)
    var circleWidth: CGFloat = 70
    var minWidth: CGFloat = UIScreen.main.bounds.size.width
    var minHeight: CGFloat = UIScreen.main.bounds.size.height
    
#elseif os(macOS)
    var circleWidth: CGFloat = 180
    var minWidth: CGFloat = 800
    var minHeight: CGFloat = 700
    
#endif
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_welcomeSeen") var user_welcomeSeen: Bool = false
    @AppStorage("user_greeting") var user_greeting: String = ""
    @AppStorage("user_authenticated") var user_authenticated: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkModel: NetworkModel
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    
    @State var currentOffering: Offering?
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var isPurchasing: Bool = false
    @State private var isRestoring: Bool = false
    @State private var isFetchingOffers: Bool = false
    @State private var showDeleteAccountSheet: Bool = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
#if os(macOS)
                ContributionMenu(showDeleteAccountSheet: $showDeleteAccountSheet)
#endif
                
                VStack(alignment: .leading, spacing: 18) {
#if os(iOS)
                    ContributionMenu(showDeleteAccountSheet: $showDeleteAccountSheet)
#endif
                    
                    (Text("Empower your focus ")
                        .fontWeight(.medium)
                     +
                     Text("ecosystem")
                        .underline()
                        .fontWeight(.bold)
                    )
                    #if os(iOS)
                    .font(.system(.title2, design: .rounded))
                    #elseif os(macOS)
                    .font(.system(.title2, design: .rounded))
                    #endif
                    .padding([.horizontal], 25)
                    
                    
                    ContributionInfo()
                    #if os(iOS)
                        .padding(.bottom, -50)
                    #endif
                    
                    Spacer()
                    
                    
                    if !isFetchingOffers {
                        PayWall()
                    }
                    
                    
                }
                .animation(.easeInOut(duration: 0.5), value: networkModel.connected && !isFetchingOffers && currentOffering != nil)
#if os(iOS)
                .frame(width: minWidth, alignment: .leading)
#elseif os(macOS)
                .padding(.bottom, 48)
                .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight, alignment: .center)
#endif
            }
            
        }
        .onAppear {
            if networkModel.connected {
                isFetchingOffers = true
                Task {
                    Purchases.shared.getOfferings { offerings, error in
                        if let offer = offerings?.current, error == nil {
                            currentOffering = offer
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                isFetchingOffers = false
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: networkModel.connected) { _ in
            if networkModel.connected {
                isFetchingOffers = true
                Task {
                    Purchases.shared.getOfferings { offerings, error in
                        if let offer = offerings?.current, error == nil {
                            currentOffering = offer
                            DispatchQueue.main.async {
                                isFetchingOffers = false
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showError) {
            VStack {
                Text("\(errorMessage)")
                    .font(.system(.headline, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                
                Spacer()
                
                Button {
                    showError = false
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(.headline, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
                        .padding(4)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                
            }
            .padding(25)
            .presentationDetents([.height(minHeight*0.40)])
        }
        .sheet(isPresented: $showDeleteAccountSheet) {
            DeleteAccountSheet(showDeleteAccountSheet: $showDeleteAccountSheet)
        }
        
    }
    
    @ViewBuilder
    func PayWall() -> some View {
        if currentOffering != nil {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Unlock smart tasks and beautiful focus modes, customized to you, with your subscription.")
                    .font(.system(.title3, design: .rounded, weight: .regular))
                    .foregroundColor(Color("Contrast"))
                
                (Text("Start 1-week free")
                    .underline()
                 +
                 Text(", then plan automatically renews for:")
                )
                .font(.system(.body, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                
                ForEach(currentOffering!.availablePackages) { package in
                    Button {
                        isPurchasing = true
                        Purchases.shared.purchase(package: package) { transaction, customerInfo, error, userCancelled in
                            if error == nil {
                                if customerInfo?.entitlements.all["All Access"]?.isActive == true {
                                    userSubscriptionModel.userSubscribed = true
                                    isPurchasing = false
                                }
                            } else if userCancelled == true {
                                isPurchasing = false
                            } else {
                                if error!.localizedDescription == "" {
                                    errorMessage = "Minor error occured, please try again."
                                } else {
                                    errorMessage = error!.localizedDescription
                                }
                                showError = true
                                isPurchasing = false
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text("\(package.storeProduct.subscriptionPeriod!.periodTitle), \(package.storeProduct.localizedPriceString)")
                                .font(.system(.body, design: .rounded, weight: .light))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(.body, design: .rounded, weight: .thin))
                            
                            let subscriptionCurrency = package.storeProduct.priceFormatter?.currencySymbol
                            
                            if subscriptionCurrency != nil {
                                (Text("\(subscriptionCurrency!)")
                                 +
                                 Text("\(package.storeProduct.pricePerMonth!)/month")
                                )
                                .font(.system(.subheadline, design: .rounded, weight: .thin))
                            }
                        }
                        .foregroundColor(Color("Contrast"))
                    }
                    .buttonStyle(.plain)
                    .disabled(isPurchasing || isRestoring)
                }
                
                HStack(spacing: 0) {
                    Button {
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
                    } label: {
                        Text("Restore purchase")
                            .font(.system(.subheadline, design: .rounded, weight: .light))
                    }
                    .buttonStyle(.plain)
                    .disabled(isPurchasing || isRestoring)
                    .padding(.trailing, 22)
                    
                    Text("Cancel anytime.")
                        .font(.system(.subheadline, design: .rounded, weight: .thin))
                    
                }
                .foregroundColor(Color("Contrast"))
                
                HStack(spacing: 0) {
                    if !isPurchasing {
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
                        Text("Processing...")
                            .font(.system(.footnote, design: .rounded, weight: .medium))
                    }
                }
                .padding(.top, -2)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 10)
            .foregroundColor(Color("Gray"))
            .background {
                Color("Background")
            }
        }
    }
    
}

struct ContributionView_Previews: PreviewProvider {
    static var previews: some View {
        ContributionView()
            .environmentObject(NetworkModel())
    }
}
