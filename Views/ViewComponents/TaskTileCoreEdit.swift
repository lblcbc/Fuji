//
//  TaskTileEditable.swift
//  Fuji
//
//  Created by Maximilian Samne on 25.03.23.
//

import SwiftUI

struct TaskTileCoreEditable: View {
    
    var taskModel: TaskModel
    @Binding var taskTitle: String
    @Binding var taskDetail: String
    @Binding var taskDeadline: Date
    @Binding var taskImportant: Bool
    @Binding var taskColor: String
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                TextField(taskModel.taskTitle, text: $taskTitle)
                    .font(.system(.title, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    .textFieldStyle(.plain)
                
#if os(macOS)
                if taskTitle == taskModel.taskTitle && taskDetail == taskModel.taskDetail && updatedTaskDeadline == taskModel.taskDeadline && taskColor == taskModel.taskColor {
                    Button {
                        edit = false
                    } label: {
                        Text("Done")
                            .font(.system(.body, design: .rounded, weight: .regular))
                            .foregroundColor(Color("Contrast"))
                    }
                    .buttonStyle(.plain)
                    .padding(3)
                } else {
                    Button {
                        // Upload Task
                    } label: {
                        Text("Save")
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundColor(Color("Contrast"))
                    }
                    .buttonStyle(.plain)
                    .padding(3)
                }
#endif
            }
            .frame(height: 39, alignment: .top)
            
            TextField(taskModel.taskDetail, text: $taskDetail)
                .font(.system(.title2, design: .rounded, weight: .regular))
                .foregroundColor(Color("Contrast"))
                .textFieldStyle(.plain)
                .frame(height: 35, alignment: .top)
            
            HStack {
                DatePicker("", selection: $taskDeadline, in: Date.now...Date.distantFuture, displayedComponents: .date)
                    .labelsHidden()
                    .font(.system(.body, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    .frame(width: 140, height: 40, alignment: .leading)
                    .onTapGesture {
                        focused.toggle()
                    }
                    .onChange(of: taskDeadline) { newValue in
                        if let range = taskTitle.range(of: "tomorrow", options: .caseInsensitive) {
                            let calendar = Calendar.current
                            let today = Date()
                            let startOfToday = calendar.startOfDay(for: today)
                            print(startOfToday.formatted(date: .abbreviated, time: .shortened))
                            let dateComponents = calendar.dateComponents([.day], from: startOfToday, to: newValue)
                            if let days = dateComponents.day, days == 1 {
                                
                            } else {
                                taskTitle = taskTitle.replacingCharacters(in: range, with: "")
                            }
                        } else if let range = taskTitle.range(of: "EOW", options: .caseInsensitive) ?? taskTitle.range(of: "end of week", options: [.caseInsensitive]) {
                            let calendar = Calendar.current
                            let today = Date()
                            let startOfWeek = calendar.startOfDay(for: today)
                            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!.addingTimeInterval(-1)
                            let dateComponents = calendar.dateComponents([.day], from: endOfWeek, to: newValue)
                            
                            if let days = dateComponents.day, days == 0 {
                                
                            } else {
                                taskTitle = taskTitle.replacingCharacters(in: range, with: "")
                            }
                        }
                    }
                
                Button { // Maybe don't even want the withAnimation here tbh
                    withAnimation(.easeInOut(duration: 0.3)) {
                        taskDeadline = addWeek(taskDeadline)
                    }
                } label: {
                    Text("+ w")
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(Color("Background"))
                        .padding(.horizontal, 14)
                        .frame(height: 30)
                        .padding(.vertical, 2)
                        .background {
                            Capsule()
                                .fill(Color("Contrast"))
                        }
                    
                }
                .buttonStyle(.plain)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        taskDeadline = addMonth(taskDeadline)
                    }
                } label: {
                    Text("+ m")
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(Color("Background"))
                        .padding(.horizontal, 14)
                        .frame(height: 30)
                        .padding(.vertical, 2)
                        .background {
                            Capsule()
                                .fill(Color("Contrast"))
                        }
                    
                }
                .buttonStyle(.plain)
                
            }
        }
    }
}


struct TaskTileEditable_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(todayTasks: .constant([TaskModel(id: "12332", userUID: "", taskTitle: "Sample Task", taskDetail: "Complete tasks detail", taskDeadline: Date().addingTimeInterval(50), taskImportant: true, taskColor: "NContrast")]), upcomingTasks: .constant([TaskModel(userUID: "", taskTitle: "Upcoming Sample Task", taskDetail: "Complete tasks detail", taskDeadline: Date.now, taskImportant: true, taskColor: "NContrast")]))
    }
}
