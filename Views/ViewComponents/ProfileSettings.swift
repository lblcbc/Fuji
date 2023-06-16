//
//  ProfileSettings.swift
//  Fuji
//
//  Created by Maximilian Samne on 01.04.23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ProfileSettings: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_greeting") var user_greeting: String = ""
    @AppStorage("user_authenticated") var user_authenticated: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Settings")
                .font(.system(.body, design: .rounded, weight: .regular))
                .foregroundColor(Color("Contrast"))
            
            Text("Time defaults")
                .font(.system(.body, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                .padding(.bottom, 2)
            
            TimeDefaultsSelector()
            
            Text("Dial color")
                .font(.system(.body, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                .padding(.bottom, 2)
            
            DialColorSelector()
                .padding(.bottom, 10)
            
            Text("Theme")
                .font(.system(.body, design: .rounded, weight: .light))
                .foregroundColor(Color("Contrast"))
                .padding(.bottom, 2)
            
            HStack(spacing: 50) {
                Text("Light")
                    .font(.system(.body, design: .rounded, weight: .thin))
                    .foregroundColor(Color("Contrast"))
                
                Text("Dark")
                    .font(.system(.body, design: .rounded, weight: .thin))
                    .foregroundColor(Color("Contrast"))
            }
            
            DialStyleSelector()
                .padding(.bottom, 40)
            
        }
        .onAppear {
            
        }
    }
}

struct ProfileSettings_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettings()
    }
}
