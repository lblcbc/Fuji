//
//  CustomTabBar.swift
//  Fuji
//
//  Created by Maximilian Samne on 30.03.23.
//

#if os(iOS)
import SwiftUI

enum Tabs: Int {
    case tasksPage = 0
    case dialPage = 1
    case profilePage = 2
    
}

struct TabBar: View {
    
    @Binding var selectedTab: Tabs
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Button {
                withAnimation(.linear(duration: 0.3)) {
                    selectedTab = .tasksPage
                }
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(.title3, design: .rounded, weight: .regular))
                    .foregroundColor(Color("Contrast"))
                    .opacity(selectedTab == .tasksPage ? 1.0 : 0.5)
            }
            .frame(width: 50)
            Spacer()
            
            Button {
                withAnimation(.linear(duration: 0.3)) {
                    selectedTab = .dialPage
                }
            } label: {
                Image(systemName: "circle.dotted")
                    .font(.system(.title3, design: .rounded, weight: .regular))
                    .foregroundColor(Color("Contrast"))
                    .opacity(selectedTab == .dialPage ? 1.0 : 0.5)
            }
            .frame(width: 50)
            Spacer()
            
            Button {
                withAnimation(.linear(duration: 0.3)) {
                    selectedTab = .profilePage
                }
            } label: {
                Image(systemName: "person")
                    .font(.system(.title3, design: .rounded, weight: .regular))
                    .foregroundColor(Color("Contrast"))
                    .opacity(selectedTab == .profilePage ? 1.0 : 0.5)
            }
            .frame(width: 50)
            Spacer()
        }
        .frame(height: 50)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selectedTab: .constant(.tasksPage))
    }
}

#endif
