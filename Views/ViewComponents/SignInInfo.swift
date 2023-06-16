//
//  SignInInfo.swift
//  Fuji
//
//  Created by Maximilian Samne on 10.04.23.
//

import SwiftUI

struct SignInInfo: View {
    
#if os(iOS)
    var circleWidth: CGFloat = UIScreen.main.bounds.size.height*0.47
    var minWidth: CGFloat = UIScreen.main.bounds.size.width
    var minHeight: CGFloat = UIScreen.main.bounds.size.height
    
#elseif os(macOS)
    var circleWidth: CGFloat = 345
    var minWidth: CGFloat = 500
    var minHeight: CGFloat = 700
    
#endif
    
    @AppStorage("user_greeting") var user_greeting: String = ""
    
    @EnvironmentObject var networkModel: NetworkModel
    
    @State private var playColor: String = "NOrange"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tasks by Fuji are ready for you!")
                .font(.system(.title3, design: .rounded, weight: .regular))
                .padding(.bottom, 10)
            
            HStack {
                Text("Easy to use")
                Image(systemName: "checkmark")
                    .font(.system(.subheadline, design: .rounded, weight: .light))
            }
            .font(.system(.body, design: .rounded, weight: .light))
            .padding(.bottom, 10)
            
            
#if os(iOS)
            if minHeight > 700 && minHeight < 860 {
                HStack {
                    Text("Streamlined organization")
                    Image(systemName: "checkmark")
                        .font(.system(.subheadline, design: .rounded, weight: .light))
                }
                .font(.system(.body, design: .rounded, weight: .light))
                .padding(.bottom, 10)
                
            } else if minHeight > 860 {
                HStack {
                    Text("Automated date setting")
                    Image(systemName: "checkmark")
                        .font(.system(.subheadline, design: .rounded, weight: .light))
                }
                .font(.system(.body, design: .rounded, weight: .light))
                .padding(.bottom, 10)
                
                HStack {
                    Text("Streamlined organization")
                    Image(systemName: "checkmark")
                        .font(.system(.subheadline, design: .rounded, weight: .light))
                }
                .font(.system(.body, design: .rounded, weight: .light))
                .padding(.bottom, 10)
            }
            
#elseif os(macOS)
            HStack {
                Text("Automated date setting")
                Image(systemName: "checkmark")
                    .font(.system(.subheadline, design: .rounded, weight: .light))
            }
            .font(.system(.body, design: .rounded, weight: .light))
            .padding(.bottom, 10)
            
            HStack {
                Text("Streamlined organization")
                Image(systemName: "checkmark")
                    .font(.system(.subheadline, design: .rounded, weight: .light))
            }
            .font(.system(.body, design: .rounded, weight: .light))
            .padding(.bottom, 10)
            
#endif
            
            
#if os(iOS)
            if minHeight > 700 {
                HStack {
                    let colors: [String] = ["NGreen","NYellow","NBlue","NOrange","NPurple","NRed", "NContrast"]
                    ForEach(colors, id: \.self) { color in
                        ZStack(alignment: .center) {
                            Circle()
                                .foregroundColor(Color(color))
                                .frame(width: 25, height: 25, alignment: .center)
                            
                            Circle()
                                .foregroundColor(Color("Background"))
                                .frame(width: 21, height: 21, alignment: .center)
                            
                            if color == playColor {
                                Circle()
                                    .foregroundColor(Color("Contrast"))
                                    .frame(width: 13, height: 13, alignment: .center)
                                Circle()
                                    .foregroundColor(Color("Background"))
                                    .frame(width: 9, height: 9, alignment: .center)
                                
                                Circle()
                                    .foregroundColor(Color("Contrast"))
                                    .frame(width: 3, height: 3, alignment: .center)
                            }
                        }
                        .contentShape(Circle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.34)) {
                                playColor = color
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
            }
            
#elseif os(macOS)
            HStack {
                let colors: [String] = ["NGreen","NYellow","NBlue","NOrange","NPurple","NRed", "NContrast"]
                ForEach(colors, id: \.self) { color in
                    ZStack(alignment: .center) {
                        Circle()
                            .foregroundColor(Color(color))
                            .frame(width: 25, height: 25, alignment: .center)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: 21, height: 21, alignment: .center)
                        
                        if color == playColor {
                            Circle()
                                .foregroundColor(Color("Contrast"))
                                .frame(width: 13, height: 13, alignment: .center)
                            Circle()
                                .foregroundColor(Color("Background"))
                                .frame(width: 9, height: 9, alignment: .center)
                            
                            Circle()
                                .foregroundColor(Color("Contrast"))
                                .frame(width: 3, height: 3, alignment: .center)
                        }
                    }
                    .contentShape(Circle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.34)) {
                            playColor = color
                        }
                    }
                }
            }
            .padding(.bottom, 10)
            
#endif
            
            HStack {
                Text("Light mode or dark mode")
                Image(systemName: "checkmark")
                    .font(.system(.subheadline, design: .rounded, weight: .light))
            }
            .font(.system(.body, design: .rounded, weight: .light))
            .padding(.bottom, 10)
            
#if os(macOS)
            HStack {
                Text("Keyboard powered")
                Image(systemName: "checkmark")
                    .font(.system(.subheadline, design: .rounded, weight: .light))
            }
            .font(.system(.body, design: .rounded, weight: .light))
            .padding(.bottom, 10)
#endif
            
            HStack {
                Text("And more")
                Image(systemName: "checkmark")
                    .font(.system(.subheadline, design: .rounded, weight: .light))
            }
            .font(.system(.body, design: .rounded, weight: .light))
            .padding(.bottom, 10)
            
            // Here I will have focus mode later when released
            
            Spacer()
            
            
            if networkModel.connected {
                Text("By signing in, you will be able to access your tasks across iPhone, iPad, and Mac, with the same subscription.")
                    .font(.system(.body, design: .rounded, weight: .regular))
                    .foregroundColor(Color("Contrast"))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 6)
                
                
                (
                    Text("We do ")
                    +
                    Text("not")
                        .underline()
                    +
                    Text(" collect personal information.")
                )
                .font(.system(.body, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
            }
        }
        .foregroundColor(Color("Contrast"))
        .padding(.horizontal, 25)
#if os(iOS)
        .frame(width: minWidth, alignment: .topLeading)
#elseif os(macOS)
        .frame(width: minWidth, alignment: .leading)
#endif
    }
    
    
    
    func limitGreetingText(_ upper: Int) {
        if user_greeting.count > upper {
            user_greeting = String(user_greeting.prefix(upper))
        }
    }
    
}

struct SignInInfo_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(NetworkModel())
    }
}
