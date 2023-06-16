//
//  FocusTaskTile.swift
//  Fuji
//
//  Created by Maximilian Samne on 16.04.23.
//

import SwiftUI

struct FocusTaskTile: View {
    
    @Binding var focusTask: TaskModel?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(focusTask?.taskTitle ?? "")
#if os(iOS)
                .font(.system(.title3, design: .rounded, weight: .light))
#elseif os(macOS)
                .font(.system(.title2, design: .rounded, weight: .light))
#endif
                .foregroundColor(Color("Contrast"))
                .padding(.horizontal, 25)
            
            HStack(spacing: 5) {
                let focusDeadlineInToday = Calendar.current.isDateInToday(focusTask?.taskDeadline ?? Date())
                if focusDeadlineInToday {
                    Text("Today")
                        .font(.system(.body, design: .rounded, weight: .thin))
                        .foregroundColor(Color("Contrast"))
                } else {
                    Text(focusTask?.taskDeadline.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .abbreviated, time: .omitted))
                        .font(.system(.body, design: .rounded, weight: .thin))
                        .foregroundColor(Color("Contrast"))
                }
                
                Text("at")
                    .font(.system(.body, design: .rounded, weight: .thin))
                    .foregroundColor(Color("Contrast"))
                
                Text((focusTask?.taskDeadline.formatted(date: .omitted, time: .shortened) ?? Date().formatted(date: .omitted, time: .shortened)) + ".")
                    .padding(.trailing, 4)
                    .font(.system(.body, design: .rounded, weight: .thin))
                    .foregroundColor(Color("Contrast"))
                
                if focusTask?.taskImportant ?? false {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(.body, design: .rounded, weight: .regular))
                        .foregroundColor(Color("Contrast"))
                        .frame(width: 20, height: 16, alignment: .center)
                }
                ZStack(alignment: .center) {
                    Circle()
                        .foregroundColor(Color(focusTask?.taskColor ?? "NContrast"))
                        .frame(width: 20, height: 20, alignment: .center)
                    
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 16, height: 16, alignment: .center)
                    
                    Circle()
                        .foregroundColor(Color("Contrast"))
                        .frame(width: 12, height: 12, alignment: .center)
                    Circle()
                        .foregroundColor(Color("Background"))
                        .frame(width: 10, height: 10, alignment: .center)
                    
                    Circle()
                        .foregroundColor(Color("Contrast"))
                        .frame(width: 3, height: 3, alignment: .center)
                }
            }
            .padding(.horizontal, 25)
            
            Text(focusTask?.taskDetail ?? "")
                .font(.system(.body, design: .rounded, weight: .thin))
                .foregroundColor(Color("Contrast"))
                .multilineTextAlignment(.leading)
                .frame(height: 44, alignment: .topLeading)
                .padding(.horizontal, 25)
        }
#if os(iOS)
        .frame(width: UIScreen.sHeight*0.40, height: 170, alignment: .center)
#elseif os(macOS)
        .frame(width: 320, height: 130, alignment: .center)
#endif
    }
}

struct FocusTaskTile_Previews: PreviewProvider {
    static var previews: some View {
#if os(iOS)
        DialView(todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "Problem set 9 and 10", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), isUpdating: .constant(false), selectedTab: .constant(.dialPage))
#elseif os(macOS)
        DialView(todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "Problem set 9 and 10", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), isUpdating: .constant(false))
#endif
    }
}
