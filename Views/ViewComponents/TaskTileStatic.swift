//
//  TaskTileStatic.swift
//  Fuji
//
//  Created by Maximilian Samne on 26.03.23.
//

import SwiftUI
import Firebase
import RevenueCat

struct TaskTileStatic: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_tasksCompleted") var user_tasksCompleted: Int = 0
    
#if os(macOS)
    @AppStorage("view_tasks") var view_tasks: Bool = false
    @AppStorage("view_dial") var view_dial: Bool = false
    @AppStorage("view_combo") var view_combo: Bool = true
#endif
    
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    
    var taskModel: TaskModel
    
    @State private var completeTaskErrorMessage: String = ""
    @State private var showCompleteTaskError: Bool = false
    
    @Binding var todayTasks: [TaskModel]
    @Binding var upcomingTasks: [TaskModel]
    @Binding var focusTask: TaskModel?
    @Binding var edit: Bool
    @Binding var isUpdating: Bool
    @Binding var uniqueUpdate: Bool
    
    
#if os(iOS)
    @Binding var selectedTab: Tabs
    
    class HapticManager {
        static let instance = HapticManager()
        
        func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
#endif
    
    var body: some View {
        ZStack {
            let index = todayTasks.firstIndex(where: { task in
                task.id == taskModel.id })
            if index == 0 {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .padding(.horizontal, 8)
                    .foregroundColor(Color("Background"))
                    .shadow(color: Color("Shadow"), radius: 5, y: 3)
                    .padding(.top, 10)
            } else {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .foregroundColor(Color("Background"))
            }
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    if index == 0 {
                        if taskModel.taskDetail != "" {
                            Text(taskModel.taskTitle)
#if os(iOS)
                                .font(.system(size: 19, weight: .thin, design: .rounded))
#elseif os(macOS)
                                .font(.system(size: 17, weight: .thin, design: .rounded))
#endif
                                .foregroundColor(Color("Contrast"))
                                .frame(height: 35)
                        } else {
                            Text(taskModel.taskTitle)
#if os(iOS)
                                .font(.system(size: 19, weight: .thin, design: .rounded))
#elseif os(macOS)
                                .font(.system(size: 17, weight: .thin, design: .rounded))
#endif
                                .foregroundColor(Color("Contrast"))
                                .frame(height: 35)
                                .padding(.bottom, 13)
                        }
                    } else {
                        if taskModel.taskDetail != "" {
                            Text(taskModel.taskTitle)
#if os(iOS)
                                .font(.system(size: 19, weight: .thin, design: .rounded))
#elseif os(macOS)
                                .font(.system(size: 17, weight: .thin, design: .rounded))
#endif
                                .foregroundColor(Color("Contrast"))
                                .frame(height: 36)
                        } else {
                            Text(taskModel.taskTitle)
#if os(iOS)
                                .font(.system(size: 19, weight: .thin, design: .rounded))
#elseif os(macOS)
                                .font(.system(size: 17, weight: .thin, design: .rounded))
#endif
                                .foregroundColor(Color("Contrast"))
                                .frame(height: 36)
                                .padding(.bottom, 13)
                        }
                    }
                    Spacer()
                    
                    if taskModel.taskDetail != "" {
                        if taskModel.taskWeekly {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                                    .rotationEffect(.degrees(-10))
                                Text("w")
                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                            }
#if os(iOS)
                            .frame(width: 58, height: 35.5, alignment: .leading)
#elseif os(macOS)
                            .frame(width: 56, height: 26, alignment: .leading)
#endif
                            
                        } else if taskModel.taskMonthly {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                                    .rotationEffect(.degrees(-10))
                                Text("m")
                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                            }
#if os(iOS)
                            .frame(width: 58, height: 35.5, alignment: .leading)
#elseif os(macOS)
                            .frame(width: 56, height: 26, alignment: .leading)
#endif
                            
                        }
                    } else {
                        if taskModel.taskWeekly {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                                    .rotationEffect(.degrees(-10))
                                Text("w")
                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                            }
#if os(iOS)
                            .frame(width: 58, height: 35.5, alignment: .leading)
#elseif os(macOS)
                            .padding(.top, 10)
                            .frame(width: 56, height: 26, alignment: .leading)
#endif
                            
                        } else if taskModel.taskMonthly {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                                    .rotationEffect(.degrees(-10))
                                Text("m")
                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                            }
#if os(iOS)
                            .frame(width: 58, height: 35.5, alignment: .leading)
#elseif os(macOS)
                            .padding(.top, 10)
                            .frame(width: 56, height: 26, alignment: .leading)
#endif
                        }
                    }
                }
#if os(iOS)
                .frame(height: 35.5, alignment: .center)
#elseif os(macOS)
                .frame(height: 26, alignment: .center)
#endif
                
                if taskModel.taskDetail != "" {
                    Text(taskModel.taskDetail)
#if os(iOS)
                        .font(.system(size: 16, weight: .thin, design: .rounded))
#elseif os(macOS)
                        .font(.system(size: 14.3, weight: .thin, design: .rounded))
#endif
                        .foregroundColor(Color("Contrast"))
                        .frame(height: 25, alignment: .center)
                        .padding(.bottom, 4)
                        .contentShape(Rectangle())
                }
                
                
                HStack {
                    Image(systemName: "calendar")
#if os(iOS)
                        .font(.system(size: 13, weight: .light, design: .rounded))
#elseif os(macOS)
                        .font(.system(size: 12, weight: .light, design: .rounded))
#endif
                        .foregroundColor(Color("Contrast"))
                        .frame(width: 14, height: 14)
                    
                    let deadlineInToday = Calendar.current.isDateInToday(taskModel.taskDeadline)
                    
                    if deadlineInToday {
                        Text("Today")
#if os(iOS)
                            .font(.system(size: 13, weight: .thin, design: .rounded))
#elseif os(macOS)
                            .font(.system(size: 12, weight: .thin, design: .rounded))
#endif
                            .foregroundColor(Color("Contrast"))
                            .frame(height: 19)
                    } else {
                        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                        let deadlineInEarlier = Calendar.current.isDate(taskModel.taskDeadline, inSameDayAs: yesterdayDate) || taskModel.taskDeadline < yesterdayDate
                        
                        Text(taskModel.taskDeadline.formatted(date: .abbreviated, time: .omitted))
#if os(iOS)
                            .font(.system(size: 13, weight: .thin, design: .rounded))
#elseif os(macOS)
                            .font(.system(size: 12, weight: .thin, design: .rounded))
#endif
                            .foregroundColor(!deadlineInEarlier ? Color("Contrast") : Color("OrangeDark"))
                            .frame(height: 19)
                    }
                    
                    Spacer()
                    
                    if taskModel.taskImportant {
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("Contrast"))
                            .frame(width: 20, height: 16, alignment: .center)
                    }
                }
                .padding(.bottom, 2)
                
                HStack {
                    Image(systemName: "clock")
#if os(iOS)
                        .font(.system(size: 13, weight: .light, design: .rounded))
#elseif os(macOS)
                        .font(.system(size: 12, weight: .light, design: .rounded))
#endif
                        .foregroundColor(Color("Contrast"))
                        .frame(width: 14, height: 14)
                    
                    Text(taskModel.taskDeadline.formatted(date: .omitted, time: .shortened))
#if os(iOS)
                        .font(.system(size: 13, weight: .thin, design: .rounded))
#elseif os(macOS)
                        .font(.system(size: 12, weight: .thin, design: .rounded))
#endif
                        .foregroundColor(taskModel.taskDeadline >= Date().addingTimeInterval(-60) ? Color("Contrast") : Color("OrangeDark"))
                        .frame(height: 20)
                    
                }
            }
            .padding(25)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            Purchases.shared.getCustomerInfo { customerInfo, error in
                if error == nil {
                    userSubscriptionModel.userSubscribed = customerInfo?.entitlements.all["All Access"]?.isActive == true
                } else {
                    userSubscriptionModel.userSubscribed = false
                }
            }
#if os(iOS)
            HapticManager.instance.impact(style: .light)
#endif
            withAnimation(.easeInOut(duration: 0.4)) {
                edit = true
            }
        }
        .overlay(alignment: .topTrailing) {
#if os(iOS)
            StaticOverlay(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, edit: $edit, isUpdating: $isUpdating, uniqueUpdate: $uniqueUpdate, selectedTab: $selectedTab)
#elseif os(macOS)
            StaticOverlay(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, edit: $edit, isUpdating: $isUpdating, uniqueUpdate: $uniqueUpdate)
#endif
        }
        .alert(completeTaskErrorMessage, isPresented: $showCompleteTaskError) {
        }
#if os(iOS)
        .frame(width: UIScreen.main.bounds.size.width, height: 170, alignment: .topLeading)
        .padding(.bottom, 10)
#elseif os(macOS)
        .frame(width: 320, height: 130, alignment: .topLeading)
        .padding(.bottom, 20)
#endif
    }
}

struct TaskTileStatic_Previews: PreviewProvider {
    static var previews: some View {
#if os(iOS)
        TaskTileStatic(taskModel: TaskModel(userUID: "", taskTitle: "Sample Task", taskDetail: "", taskDeadline: Date(), taskImportant: true, taskColor: "NYellow", taskWeekly: false, taskMonthly: true), todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "PS 8 and 9", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), edit: .constant(false), isUpdating: .constant(false), uniqueUpdate: .constant(false), selectedTab: .constant(.tasksPage))
            .environmentObject(NetworkModel())
            .environmentObject(UserSubscriptionModel())
        
#elseif os(macOS)
        TaskTileStatic(taskModel: TaskModel(userUID: "", taskTitle: "Sample Task", taskDetail: "", taskDeadline: Date(), taskImportant: true, taskColor: "NYellow", taskWeekly: false, taskMonthly: true), todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "PS 8 and 9", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), edit: .constant(false), isUpdating: .constant(false), uniqueUpdate: .constant(false))
            .environmentObject(NetworkModel())
            .environmentObject(UserSubscriptionModel())
#endif
    }
}
