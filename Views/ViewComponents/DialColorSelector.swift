//
//  DialColorSelector.swift
//  Fuji
//
//  Created by Maximilian Samne on 10.04.23.
//

import SwiftUI

struct DialColorSelector: View {
    
    @AppStorage("user_dial") var user_dial: String = "Yellow"
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    user_dial = "Yellow"
                }
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2")]), center: .center))
                        .frame(width: 30)
                        .blur(radius: 4)
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 23)
                    if user_dial == "Yellow" {
                        Image(systemName: "checkmark")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
            }
            .buttonStyle(.plain)
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    user_dial = "Green"
                }
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Green2")]), startPoint: .topTrailing, endPoint: .bottomLeading))
                        .frame(width: 30)
                        .blur(radius: 4)
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 23)
                    if user_dial == "Green" {
                        Image(systemName: "checkmark")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
            }
            .buttonStyle(.plain)
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    user_dial = "Purple"
                }
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Purple2"), Color("Purple4"), Color("Purple5"), Color("Purple6"), Color("Purple7"), Color("Purple8"), Color("Purple1"), Color("Purple2"), Color("Purple2")]), center: .center))
                        .frame(width: 30)
                        .blur(radius: 5)
                        .rotationEffect(.degrees(260))
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 23)
                    if user_dial == "Purple" {
                        Image(systemName: "checkmark")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
            }
            .buttonStyle(.plain)
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    user_dial = "Blue"
                }
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Blue2")]), startPoint: .topTrailing, endPoint: .bottomLeading))
                        .frame(width: 30)
                        .blur(radius: 5)
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 23)
                    if user_dial == "Blue" {
                        Image(systemName: "checkmark")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
            }
            .buttonStyle(.plain)
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    user_dial = "Orange"
                }
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Orange2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 30)
                        .blur(radius: 5)
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 23)
                    if user_dial == "Orange" {
                        Image(systemName: "checkmark")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct DialColorSelector_Previews: PreviewProvider {
    static var previews: some View {
        DialColorSelector()
    }
}
