//
//  TaskColorSelectors.swift
//  Fuji
//
//  Created by Maximilian Samne on 28.03.23.
//

import SwiftUI

struct TaskColorSelector: View {
    
    @Binding var taskColor: String
    
    var body: some View {
#if os(iOS)
        GeometryReader { geo in
            HStack(spacing: 11) {
                let colors: [String] = ["NGreen","NYellow","NBlue","NOrange","NPurple","NRed", "NContrast"]
                ForEach(colors, id: \.self) { color in
                    ZStack(alignment: .center) {
                        Circle()
                            .foregroundColor(Color(color))
                            .frame(width: 25, height: 25, alignment: .center)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: 21, height: 21, alignment: .center)
                        
                        if taskColor == color {
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
                            taskColor = color
                        }
                    }
                }
            }
            .frame(width: geo.size.width, height: 29, alignment: .center)
        }
        .frame(height: 29, alignment: .center)
        
#elseif os(macOS)
        HStack(spacing: 18.16) {
            let colors: [String] = ["NGreen","NYellow","NBlue","NOrange","NPurple","NRed", "NContrast"]
            ForEach(colors, id: \.self) { color in
                ZStack(alignment: .center) {
                    Circle()
                        .foregroundColor(Color(color))
                        .frame(width: 23, height: 21, alignment: .center)
                    
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 17, height: 17, alignment: .center)
                    
                    if taskColor == color {
                        Circle()
                            .foregroundColor(Color("Contrast"))
                            .frame(width: 11, height: 11, alignment: .center)
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: 9, height: 9, alignment: .center)
                        
                        Circle()
                            .foregroundColor(Color("Contrast"))
                            .frame(width: 2, height: 2, alignment: .center)
                    }
                }
                .contentShape(Circle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.34)) {
                        taskColor = color
                    }
                }
                
            }
        }
        .frame(height: 38, alignment: .center)
#endif
    }
}

struct TaskColorSelector_Previews: PreviewProvider {
    static var previews: some View {
        TaskColorSelector(taskColor: .constant("NContrast"))
    }
}
