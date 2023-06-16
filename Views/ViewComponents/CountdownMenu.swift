//
//  CountdownMenu.swift
//  Fuji
//
//  Created by Maximilian Samne on 15.04.23.
//

import SwiftUI
import RevenueCat
import AudioToolbox

struct CountdownMenu: View {
    
    
    @AppStorage("original_time") var original_time: Double = 1200
    @AppStorage("time_remaining") var time_remaining: Double = 1200
    @AppStorage("user_timeFocused") var user_timeFocused: Double = 0.0
    
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    
    let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
    
    @Binding var focusTask: TaskModel?
    
    @Binding var isTimerStarted: Bool
    
    
    
#if os(iOS)
    class HapticManager {
        static let instance = HapticManager()
        
        func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
#endif
    
    
    var body: some View {
        VStack(spacing: 7) {
            if isTimerStarted {
                HStack {
                    if time_remaining > 3600 {
                        let remainingHours = (time_remaining/3600)
                        let roundedHours = remainingHours.rounded(.down)
                        
                        let remainingMinutes = (time_remaining-3600*roundedHours)/60
                        
                        (
                            Text("\(roundedHours, specifier: "%.0f")h  ")
                            + Text("\(remainingMinutes, specifier: "%.1f")m  ")
                        )
                        .font(.system(.title, design: .rounded, weight: .thin))
                        
                    } else {
                        let remainingMinutes = (time_remaining)/60
                        
                        Text("\(remainingMinutes, specifier: "%.1f")m  ")
                            .font(.system(.title, design: .rounded, weight: .thin))
                    }
                }
#if os(iOS)
                .frame(width: 300, height: 50, alignment: .center)
#elseif os(macOS)
                .frame(width: 300, height: 50, alignment: .center)
#endif
            } else {
                Menu {
                    Button {
                        original_time = 300.0 // 5 min
                        time_remaining = 300.0
                    } label: {
                        Text("5 minutes")
                            .font(.system(.title3, design: .rounded, weight: .light))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        original_time = 600.0 // 10 min
                        time_remaining = 600.0
                        
                    } label: {
                        Text("10 minutes")
                            .font(.system(.title3, design: .rounded, weight: .light))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        original_time = 1200.0 // 20 min
                        time_remaining = 1200.0
                    } label: {
                        Text("20 minutes")
                            .font(.system(.title3, design: .rounded, weight: .light))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        original_time = 1800.0 // 30 min
                        time_remaining = 1800.0
                    } label: {
                        Text("30 minutes")
                            .font(.system(.title3, design: .rounded, weight: .light))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        original_time = 2700.0 // 45 min
                        time_remaining = 2700.0
                    } label: {
                        Text("45 minutes")
                            .font(.system(.title3, design: .rounded, weight: .light))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        original_time = 3600.0 // 1h min
                        time_remaining = 3600.0
                    } label: {
                        Text("1 hour")
                            .font(.system(.title3, design: .rounded, weight: .light))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        original_time = 5400.0 // 1.5h min
                        time_remaining = 5400.0
                    } label: {
                        Text("1.5 hours")
                            .font(.system(.title3, design: .rounded, weight: .light))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        original_time = 7200.0 // 2h min
                        time_remaining = 7200.0
                    } label: {
                        Text("2 hours")
                            .font(.system(.title3, design: .rounded, weight: .light))
                    }
                    .buttonStyle(.plain)
                    
                } label: {
                    if original_time != 0 {
                        if time_remaining > 3600 {
                            let remainingHours = (time_remaining/3600)
                            let roundedHours = remainingHours.rounded(.down)
                            
                            let remainingMinutes = (time_remaining-3600*roundedHours)/60
                            let roundedMinutes = remainingMinutes.rounded(.down)
                            
                            let remainingSeconds = (time_remaining-3600*roundedHours-60*roundedMinutes)
                            
                            (Text("\(roundedHours, specifier: "%.0f")h  ")
                             + Text("\(roundedMinutes, specifier: "%.0f")m  ")
                             + Text("\(remainingSeconds, specifier: "%.0f")s"))
                            .font(.system(.title, design: .rounded, weight: .thin))
                            .frame(width: 300, height: 50, alignment: .center)
                        } else {
                            let remainingMinutes = (time_remaining)/60
                            let roundedMinutes = remainingMinutes.rounded(.down)
                            let remainingSeconds = (time_remaining-60*roundedMinutes)
                            
                            (Text("\(roundedMinutes, specifier: "%.0f")m  ")
                             + Text("\(remainingSeconds, specifier: "%.0f")s"))
                            .font(.system(.title, design: .rounded, weight: .thin))
                            .frame(width: 200, height: 50, alignment: .center)
                        }
                    } else {
                        Text("Set focus")
                            .font(.system(.title, design: .rounded, weight: .thin))
                    }
                }
                .menuStyle(.borderlessButton)
                .padding(90)
#if os(iOS)
                .frame(width: 300, height: 50, alignment: .center)
#elseif os(macOS)
                .frame(width: 300, height: 50, alignment: .center)
#endif
            }
            
            HStack(spacing: 20) {
                Button {
                    if !isTimerStarted {
                        Purchases.shared.getCustomerInfo { customerInfo, error in
                            if error == nil {
                                userSubscriptionModel.userSubscribed = customerInfo?.entitlements.all["All Access"]?.isActive == true
                            } else {
                                userSubscriptionModel.userSubscribed = false
                            }
                        }
                    }
#if os(iOS)
                    if !isTimerStarted {
                        HapticManager.instance.impact(style: .medium)
                    } else {
                        HapticManager.instance.impact(style: .light)
                    }
#endif
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isTimerStarted.toggle()
                    }
                    
                    if isTimerStarted {
                        time_remaining -= 6
                    }
                } label: {
                    if !isTimerStarted {
                        if focusTask == nil {
                            Text("Start")
#if os(iOS)
                                .font(.system(.body, design: .rounded, weight: .light))
                                .frame(width: 52)
#elseif os(macOS)
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .frame(width: 60)
#endif
                                .foregroundColor(Color("Contrast"))
                            
                        } else {
                            Text("Start")
#if os(iOS)
                                .font(.system(.body, design: .rounded, weight: .regular))
#elseif os(macOS)
                                .font(.system(.title3, design: .rounded, weight: .light))
#endif
                                .frame(width: 80, height: 30)
                                .foregroundColor(Color("Background"))
                                .background {
                                    Capsule()
                                        .fill(Color("Contrast"))
                                }
                        }
                    } else {
                        if focusTask == nil {
                            Text("Pause")
#if os(iOS)
                                .font(.system(.body, design: .rounded, weight: .thin))
                                .frame(width: 52)
#elseif os(macOS)
                                .font(.system(.title3, design: .rounded, weight: .thin))
                                .frame(width: 60)
#endif
                                .foregroundColor(Color("Contrast"))
                        } else {
                            Text("Pause")
#if os(iOS)
                                .font(.system(.body, design: .rounded, weight: .thin))
#elseif os(macOS)
                                .font(.system(.title3, design: .rounded, weight: .thin))
#endif
                                .frame(width: 80, height: 30)
                                .foregroundColor(Color("Contrast"))
                        }
                    }
                }
                .buttonStyle(.plain)
                
                Button {
#if os(iOS)
                    HapticManager.instance.impact(style: .light)
#endif
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isTimerStarted = false
                        time_remaining = original_time
                    }
                } label: {
                    if focusTask == nil {
                        Text("Reset")
#if os(iOS)
                                .font(.system(.body, design: .rounded, weight: .thin))
                                .frame(width: 52)
#elseif os(macOS)
                                .font(.system(.title3, design: .rounded, weight: .thin))
                                .frame(width: 60)
#endif
                                .foregroundColor(Color("Contrast"))
                    } else {
                        Text("Reset")
#if os(iOS)
                            .font(.system(.body, design: .rounded, weight: .thin))
#elseif os(macOS)
                            .font(.system(.title3, design: .rounded, weight: .thin))
#endif
                            .frame(width: 80)
                            .foregroundColor(Color("Contrast"))
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .onReceive(timer) { _ in
            if isTimerStarted {
                if time_remaining > 0 {
                    time_remaining -= 6
                    user_timeFocused += 6
                } else {
                    isTimerStarted = false
                }
            }
        }
    }
}

struct CountdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        CountdownMenu(focusTask: .constant(nil), isTimerStarted: .constant(false))
    }
}
