//
//  MacNavigationMenu.swift
//  Fuji
//
//  Created by Maximilian Samne on 01.04.23.
//

#if os(macOS)
import SwiftUI

struct MacNavigationMenu: View {
    
    @AppStorage("user_greeting") var user_greeting: String = ""
    @AppStorage("view_tasks") var view_tasks: Bool = false
    @AppStorage("view_dial") var view_dial: Bool = false
    @AppStorage("view_combo") var view_combo: Bool = true
    @Binding var viewProfile: Bool
    
    @EnvironmentObject var networkModel: NetworkModel
    
    let currentHour = Calendar.current.dateComponents([.hour], from: Date()).hour
    
    var body: some View {
        HStack(alignment: .top) {
            Menu {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewProfile = false
                        view_combo = true
                        view_dial = false
                        view_tasks = false
                    }
                } label: {
                    HStack {
                        Text("Tasks + Focus")
                            .font(.system(.subheadline, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                        if view_combo && !viewProfile {
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .light, design: .rounded))
                                .foregroundColor(Color("Contrast"))
                        }
                    }
                }
                .buttonStyle(.plain)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewProfile = false
                        view_tasks = true
                        view_dial = false
                        view_combo = false
                    }
                } label: {
                    HStack {
                        Text("Tasks")
                            .font(.system(.subheadline, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                        if view_tasks && !viewProfile {
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .light, design: .rounded))
                                .foregroundColor(Color("Contrast"))
                        }
                    }
                }
                .buttonStyle(.plain)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewProfile = false
                        view_dial = true
                        view_combo = false
                        view_tasks = false
                    }
                } label: {
                    HStack {
                        Text("Focus")
                            .font(.system(.subheadline, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                        if view_dial && !viewProfile {
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .light, design: .rounded))
                                .foregroundColor(Color("Contrast"))
                        }
                    }
                }
                .buttonStyle(.plain)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewProfile.toggle()
                    }
                } label: {
                    Image(systemName: "person")
                        .font(.system(.subheadline, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
                    if viewProfile {
                        Image(systemName: "checkmark")
                            .font(.system(size: 8, weight: .light, design: .rounded))
                            .foregroundColor(Color("Contrast"))
                    }
                }
                .buttonStyle(.plain)
                
                
            } label: {
                Image(systemName: "gear")
                    .font(.system(.title2, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    .opacity(0.9)
            }
            .buttonStyle(.plain)
            
            
            if user_greeting != "" {
                if currentHour! < 12 {
                    Text("Good morning, \(user_greeting).")
                        .font(.system(.title2, design: .rounded, weight: .thin))
                        .padding(.bottom, 16)
                } else if currentHour! >= 12 {
                    Text("Good evening, \(user_greeting).")
                        .font(.system(.title2, design: .rounded, weight: .thin))
                        .padding(.bottom, 16)
                } else {
                    Text("Hello, \(user_greeting).")
                        .font(.system(.title2, design: .rounded, weight: .thin))
                        .padding(.bottom, 16)
                }
            } else {
                if currentHour! < 12 {
                    Text("Good morning.")
                        .font(.system(.title2, design: .rounded, weight: .thin))
                        .padding(.bottom, 16)
                } else if currentHour! >= 12 {
                    Text("Good evening.")
                        .font(.system(.title2, design: .rounded, weight: .thin))
                        .padding(.bottom, 16)
                } else {
                    Text("Hello.")
                        .font(.system(.title2, design: .rounded, weight: .thin))
                        .padding(.bottom, 16)
                }
            }
            
            if !networkModel.connected {
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(.title3, design: .rounded, weight: .light))
                    .foregroundColor(Color("Gray"))
                    .padding(.leading, 10)
            }
            
            Spacer()
        }
        .padding(.leading, 25)
        .padding(.top, 10)
    }
}

#endif
