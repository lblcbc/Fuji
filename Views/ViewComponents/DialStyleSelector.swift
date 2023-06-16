//
//  DialStyleSelector.swift
//  Fuji
//
//  Created by Maximilian Samne on 10.04.23.
//

import SwiftUI

struct DialStyleSelector: View {
    
    @AppStorage("user_dialThinL") var user_dialThinL: Bool = false
    @AppStorage("user_dialThinD") var user_dialThinD: Bool = false
    
    var body: some View {
        HStack {
            Button {
                user_dialThinL = false
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
                    
                    if !user_dialThinL {
                        Image(systemName: "checkmark")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
            }
            .buttonStyle(.plain)
            
            
            Button {
                user_dialThinL = true
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2")]), center: .center))
                        .frame(width: 27)
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 23)
                    
                    if user_dialThinL {
                        Image(systemName: "checkmark")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
                .padding(.trailing, 10)
            }
            .buttonStyle(.plain)
            
            
            Button {
                user_dialThinD = false
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
                    
                    if !user_dialThinD {
                        Image(systemName: "checkmark")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
            }
            .buttonStyle(.plain)
            
            
            Button {
                user_dialThinD = true
            } label: {
                ZStack {
                    Circle()
                        .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2")]), center: .center))
                        .frame(width: 27)
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 23)
                    
                    if user_dialThinD {
                        Image(systemName: "checkmark")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                }
                .padding(.trailing, 10)
            }
            .buttonStyle(.plain)
        }
    }
}

struct DialStyleSelector_Previews: PreviewProvider {
    static var previews: some View {
        DialStyleSelector()
    }
}
