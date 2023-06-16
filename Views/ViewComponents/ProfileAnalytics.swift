//
//  ProfileAnalytics.swift
//  Fuji
//
//  Created by Maximilian Samne on 31.03.23.
//

import SwiftUI

struct ProfileAnalytics: View {
    
    @AppStorage("user_timeFocused") var user_timeFocused: Double = 0.0
    @AppStorage("user_tasksCompleted") var user_tasksCompleted: Int = 0
    
    var body: some View {
        HStack {
            VStack {
                Text("Hours in focus")
                    .font(.system(.body, design: .rounded, weight: .light))
                
                let hoursFocused = user_timeFocused/3600
                Text("\(hoursFocused, specifier: "%.1f")")
                    .font(.system(.title, design: .rounded, weight: .medium))
            }
            .padding(.trailing, 20)
            
            VStack {
                Text("Tasks completed")
                    .font(.system(.body, design: .rounded, weight: .light))
                
                Text("\(user_tasksCompleted)")
                    .font(.system(.title, design: .rounded, weight: .medium))
            }
        }
        .foregroundColor(Color("Contrast"))
        .padding(.vertical, 5)
        .padding(.bottom, 20)
    }
}

struct ProfileAnalytics_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAnalytics()
    }
}
