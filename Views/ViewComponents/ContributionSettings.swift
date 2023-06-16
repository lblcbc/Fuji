//
//  ContributionSettings.swift
//  Fuji
//
//  Created by Maximilian Samne on 10.04.23.
//

import SwiftUI

struct ContributionSettings: View {
    
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
        VStack(alignment: .leading, spacing: 8) {
            Text("Customize Fuji for you")
                .font(.system(.title3, design: .rounded, weight: .regular))
                .foregroundColor(Color("Contrast"))
            
            Text("Personalize focus")
                .font(.system(.title3, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                .padding(.bottom, 6)
            
            DialColorSelector()
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Choose your style")
                    .font(.system(.body, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    .padding(.bottom, 6)
                
                HStack(spacing: 50) {
                    Text("Light")
                        .font(.system(.body, design: .rounded, weight: .thin))
                        .foregroundColor(Color("Contrast"))
                    
                    Text("Dark")
                        .font(.system(.body, design: .rounded, weight: .thin))
                        .foregroundColor(Color("Contrast"))
                }
                .padding(.bottom, 10)
                
                DialStyleSelector()
                    .padding(.bottom, 25)
            }
        }
        .font(.system(.title3, design: .rounded, weight: .regular))
        .foregroundColor(Color("Contrast"))
        .padding(.horizontal, 25)
#if os(iOS)
        .frame(width: minWidth, alignment: .leading)
#elseif os(macOS)
        .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight*0.54, maxHeight: minHeight*0.7, alignment: .leading)
        .background {
            Color("Background")
        }
#endif
    }
}

struct ContributionSettings_Previews: PreviewProvider {
    static var previews: some View {
        ContributionSettings()
    }
}
