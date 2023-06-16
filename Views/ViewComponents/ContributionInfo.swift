//
//  ContributionInfo.swift
//  Fuji
//
//  Created by Maximilian Samne on 09.04.23.
//

import SwiftUI

struct ContributionInfo: View {
    
#if os(iOS)
    var circleWidth: CGFloat = 100
    var minWidth: CGFloat = UIScreen.main.bounds.size.width
    var minHeight: CGFloat = UIScreen.main.bounds.size.height
    
#elseif os(macOS)
    var circleWidth: CGFloat = 200
    var minWidth: CGFloat = 800
    var minHeight: CGFloat = 700
    
#endif
    
    
    var body: some View {
        TabView {
            HStack(spacing: -1) {
                ZStack {
                    Circle()
                        .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow1"), Color("Yellow2"), Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3")]), center: .center))
                        .rotationEffect(.degrees(180))
                        .frame(width: circleWidth+20)
                        .blur(radius: 15)
                    
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: circleWidth)
                    
                    Text("Focus")
                        .font(.system(.body, design: .rounded, weight: .regular))
                        .foregroundColor(Color("Contrast"))
                }
                
                Text("enhanced")
                    .font(.system(.body, design: .rounded, weight: .thin))
                    .foregroundColor(Color("Contrast"))
            }
            .padding(.horizontal, 25)
#if os(iOS)
            .frame(width: minWidth, alignment: .leading)
#elseif os(macOS)
            .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight*0.48, maxHeight: minHeight*0.7, alignment: .leading)
            .background {
                Color("Background")
            }
#endif
            
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .foregroundColor(Color("Background"))
                    .frame(width: 240, height: 110)
                    .shadow(color: Color("Shadow"), radius: 5, y: 3)
                
                Text("Beauty in simplicity")
                    .font(.system(.title3, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    .padding(.leading, 25)
                
                Image(systemName: "checkmark")
                    .font(.system(.subheadline, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    .padding(.bottom, 56)
                    .padding(.leading, 207)
                
            }
            .padding(.horizontal, 25)
#if os(iOS)
            .frame(width: minWidth, alignment: .leading)
#elseif os(macOS)
            .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight*0.48, maxHeight: minHeight*0.7, alignment: .leading)
            .background {
                Color("Background")
            }
#endif
            
            TypeRecognitionText()
            
            ContributionSettings()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("For you, and the planet 🌱🌍")
                    .font(.system(.title3, design: .rounded, weight: .regular))
                    .foregroundColor(Color("Contrast"))
                    .padding(.horizontal, 25)
                
                Text("And so much more.")
                    .font(.system(.title3, design: .rounded, weight: .regular))
                    .foregroundColor(Color("Contrast"))
                    .padding(.horizontal, 25)
                
                Text("with Fuji.")
                    .font(.system(.body, design: .rounded, weight: .regular))
                    .foregroundColor(Color("Contrast"))
                    .padding(.horizontal, 25)
            }
#if os(iOS)
            .frame(width: minWidth, alignment: .leading)
#elseif os(macOS)
            .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight*0.48, maxHeight: minHeight*0.7, alignment: .leading)
            .background {
                Color("Background")
            }
#endif
        }
#if os(iOS)
        .frame(width: minWidth, height: minHeight*0.41, alignment: .leading)
        .tabViewStyle(.page)
#elseif os(macOS)
        .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight*0.48, maxHeight: minHeight*0.7, alignment: .leading)
#endif
        
    }
    
    @ViewBuilder
    func TypeRecognitionText() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Type recognition")
                .font(.system(.title3, design: .rounded, weight: .regular))
                .foregroundColor(Color("Contrast"))
                .padding(.horizontal, 25)
            
            Text("Automated date setting")
                .font(.system(.title3, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                .padding(.horizontal, 25)
            
            HStack {
                Text("EOW")
                    .frame(width: 37, alignment: .leading)
                
                Image(systemName: "arrow.right")
                    .font(.system(.caption, design: .rounded, weight: .thin))
                
                Text("End of week")
            }
            .font(.system(.body, design: .rounded, weight: .thin))
            .foregroundColor(Color("Contrast"))
            .padding(.horizontal, 25)
            
            HStack {
                Text("EOM")
                    .frame(width: 37, alignment: .leading)
                
                Image(systemName: "arrow.right")
                    .font(.system(.caption, design: .rounded, weight: .thin))
                
                Text("End of month")
            }
            .font(.system(.body, design: .rounded, weight: .thin))
            .foregroundColor(Color("Contrast"))
            .padding(.horizontal, 25)
            
            HStack {
                Text("tdat")
                    .frame(width: 37, alignment: .leading)
                
                Image(systemName: "arrow.right")
                    .font(.system(.caption, design: .rounded, weight: .thin))
                
                Text("Today + 2")
            }
            .font(.system(.body, design: .rounded, weight: .thin))
            .foregroundColor(Color("Contrast"))
            .padding(.horizontal, 25)
            
            
            HStack {
                Text("tomorrow")
                
                Image(systemName: "arrow.right")
                    .font(.system(.caption, design: .rounded, weight: .thin))
                
                Text("Today + 1")
            }
            .font(.system(.body, design: .rounded, weight: .thin))
            .foregroundColor(Color("Contrast"))
            .padding(.horizontal, 25)
            
            HStack { 
                Image(systemName: "sunrise")
                    .font(.system(.body, design: .rounded, weight: .thin))
                Image(systemName: "sun.max")
                    .font(.system(.body, design: .rounded, weight: .thin))
                Image(systemName: "sunset")
                    .font(.system(.body, design: .rounded, weight: .thin))
                Image(systemName: "moon")
                    .font(.system(.subheadline, design: .rounded, weight: .thin))
            }
            .font(.system(.body, design: .rounded, weight: .thin))
            .foregroundColor(Color("Contrast"))
            .padding(.horizontal, 25)
            
        }
#if os(iOS)
        .frame(width: minWidth, alignment: .leading)
#elseif os(macOS)
        .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight*0.48, maxHeight: minHeight*0.7, alignment: .leading)
        .background {
            Color("Background")
        }
#endif
        
#if os(macOS)
        VStack(alignment: .leading, spacing: 8) {
            Text("Keyboard powered")
                .font(.system(.title3, design: .rounded, weight: .regular))
                .foregroundColor(Color("Contrast"))
                .padding(.horizontal, 25)
            
            Text("Create and edit tasks easier and faster with your keyboard")
                .font(.system(.title3, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                .padding(.horizontal, 25)
            
            HStack(spacing: 0) {
                Text("Navigate with tab ")
                
                Image(systemName: "arrow.right.to.line")
            }
            .font(.system(.body, design: .rounded, weight: .thin))
            .foregroundColor(Color("Contrast"))
            .padding(.horizontal, 25)
            
            HStack(spacing: 0) {
                Text("Create and update with enter ")
                
                Image(systemName: "arrow.uturn.right.square")
                    .rotationEffect(.degrees(180))
            }
            .font(.system(.body, design: .rounded, weight: .thin))
            .foregroundColor(Color("Contrast"))
            .padding(.horizontal, 25)
            
            HStack(spacing: 0) {
                Text("Exit with esc")
                
            }
            .font(.system(.body, design: .rounded, weight: .thin))
            .foregroundColor(Color("Contrast"))
            .padding(.horizontal, 25)
        }
        
        .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight*0.48, maxHeight: minHeight*0.7, alignment: .leading)
        .background {
            Color("Background")
        }
#endif
    }
}

struct ContributionInfo_Previews: PreviewProvider {
    static var previews: some View {
        ContributionView()
            .environmentObject(NetworkModel())
    }
}
