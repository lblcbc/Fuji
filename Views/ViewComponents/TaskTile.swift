//
//  TaskTile.swift
//  Fuji
//
//  Created by Maximilian Samne on 22.03.23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import RevenueCat

struct TaskTile: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_time") var user_time: Int = 12
    @AppStorage("user_morning") var user_morning: Int = 8
    @AppStorage("user_midday") var user_midday: Int = 12
    @AppStorage("user_evening") var user_evening: Int = 18
    @AppStorage("user_night") var user_night: Int = 21
    
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    
#if os(iOS)
    @Environment(\.scenePhase) var scenePhase
#endif
    
    var taskModel: TaskModel
    
#if os(macOS)
    @State private var isWindowForemost = false
#endif
    
    @State var taskTitle: String = ""
    @State var taskDetail: String = ""
    @State var taskDeadline: Date = Date()
    @State var taskImportant: Bool = false
    @State var taskColor: String = "NContrast"
    @State var taskWeekly: Bool = false
    @State var taskMonthly: Bool = false
    @State var edit: Bool = false
    @State private var showCreate: Bool = false
    @State private var uniqueUpdate: Bool = false
    
    
    @Binding var todayTasks: [TaskModel]
    @Binding var upcomingTasks: [TaskModel]
#if os(iOS)
    @Binding var showTodayTasks: Bool
    @Binding var selectedTab: Tabs
#endif
    @Binding var focusTask: TaskModel?
    @Binding var isUpdating: Bool
    @Binding var newTask: Bool
    
    
    
    var body: some View {
#if os(iOS)
        ZStack {
            if taskModel.id != nil {
                TaskTileStatic(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, edit: $edit, isUpdating: $isUpdating, uniqueUpdate: $uniqueUpdate, selectedTab: $selectedTab)
                    .sheet(isPresented: $edit) {
                        TaskSheet(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, edit: $edit, isUpdating: $isUpdating, newTask: $newTask, showTodayTasks: $showTodayTasks, taskTitle: $taskTitle, taskDetail: $taskDetail, taskDeadline: $taskDeadline, taskImportant: $taskImportant, taskColor: $taskColor, taskWeekly: $taskWeekly, taskMonthly: $taskMonthly)
                            .presentationDetents([.height(UIScreen.sHeight*0.35)])
                            .onAppear {
                                taskTitle = taskModel.taskTitle
                                taskDetail = taskModel.taskDetail
                                taskDeadline = taskModel.taskDeadline
                                taskImportant = taskModel.taskImportant
                                taskColor = taskModel.taskColor
                                taskWeekly = taskModel.taskWeekly
                                taskMonthly = taskModel.taskMonthly
                            }
                    }
                    .onChange(of: scenePhase) { newScene in
                        if !isUpdating {
                            if newScene == .active {
                                print("on change of scene")
                                let calendar = Calendar.current
                                let today = calendar.startOfDay(for: Date())
                                let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
                                
                                if taskModel.taskDeadline < tomorrow! {
                                    if let _ = upcomingTasks.firstIndex(where: { upcomingTask in
                                        upcomingTask.id == taskModel.id
                                    }) {
                                        print("task currently in upcoming")
                                        upcomingTasks.removeAll { taskModel.id == $0.id }
                                        todayTasks.removeLast()
                                        todayTasks.append(taskModel)
                                        todayTasks.sort {
                                            $0.taskDeadline < $1.taskDeadline
                                        }
                                        todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
                                    }
                                }
                            }
                        }
                    }
                    .disabled(uniqueUpdate)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    Text("New Task")
                        .font(.system(size: 19, weight: .thin, design: .rounded))
                        .foregroundColor(Color("Contrast").opacity(0.4))
                        .frame(width: UIScreen.sWidth-100, height: 170, alignment: .topLeading)
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
                    edit = true
                }
                .padding(25)
                .frame(width: UIScreen.sWidth, height: 260, alignment: .topLeading)
                .sheet(isPresented: $edit) {
                    TaskSheet(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, edit: $edit, isUpdating: $isUpdating, newTask: $newTask, showTodayTasks: $showTodayTasks, taskTitle: $taskTitle, taskDetail: $taskDetail, taskDeadline: $taskDeadline, taskImportant: $taskImportant, taskColor: $taskColor, taskWeekly: $taskWeekly, taskMonthly: $taskMonthly)
                        .presentationDetents([.height(UIScreen.sHeight*0.35)])
                        .onAppear {
                            taskTitle = ""
                            taskDetail = ""
                            taskDeadline = Date()
                            taskImportant = false
                            taskColor = "NContrast"
                            taskWeekly = false
                            taskMonthly = false
                        }
                }
            }
        }
        .sheet(isPresented: $newTask, onDismiss: {
            newTask = false
        }) {
            TaskSheet(taskModel: TaskModel(id: nil, userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false), todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, edit: $edit, isUpdating: $isUpdating, newTask: $newTask, showTodayTasks: $showTodayTasks, taskTitle: $taskTitle, taskDetail: $taskDetail, taskDeadline: $taskDeadline, taskImportant: $taskImportant, taskColor: $taskColor, taskWeekly: $taskWeekly, taskMonthly: $taskMonthly)
                .presentationDetents([.height(UIScreen.sHeight*0.35)])
                .onAppear {
                    taskTitle = ""
                    taskDetail = ""
                    taskDeadline = Date()
                    taskImportant = false
                    taskColor = "NContrast"
                    taskWeekly = false
                    taskMonthly = false
                }
        }
        
#elseif os(macOS)
        ZStack {
            if taskModel.id != nil {
                if edit {
                    TaskTileEditable(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, edit: $edit, isUpdating: $isUpdating, newTask: $newTask, taskTitle: $taskTitle, taskDetail: $taskDetail, taskDeadline: $taskDeadline, taskImportant: $taskImportant, taskColor: $taskColor, taskWeekly: $taskWeekly, taskMonthly: $taskMonthly)
                        .onAppear {
                            taskTitle = taskModel.taskTitle
                            taskDetail = taskModel.taskDetail
                            taskDeadline = taskModel.taskDeadline
                            taskImportant = taskModel.taskImportant
                            taskColor = taskModel.taskColor
                            taskWeekly = taskModel.taskWeekly
                            taskMonthly = taskModel.taskMonthly
                        }
                } else {
                    TaskTileStatic(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, edit: $edit, isUpdating: $isUpdating, uniqueUpdate: $uniqueUpdate)
                        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                            isWindowForemost = true
                        }
                        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification)) { _ in
                            isWindowForemost = false
                        }
                        .onChange(of: isWindowForemost) { _ in
                            if isWindowForemost {
                                if !isUpdating {
                                    let calendar = Calendar.current
                                    let today = calendar.startOfDay(for: Date())
                                    let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
                                    
                                    if taskModel.taskDeadline < tomorrow! {
                                        if let _ = upcomingTasks.firstIndex(where: { upcomingTask in
                                            upcomingTask.id == taskModel.id
                                        }) {
                                            print("task currently in upcoming")
                                            upcomingTasks.removeAll { taskModel.id == $0.id }
                                            todayTasks.removeLast()
                                            todayTasks.append(taskModel)
                                            todayTasks.sort {
                                                $0.taskDeadline < $1.taskDeadline
                                            }
                                            todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
                                        }
                                    }
                                }
                            } else {
                            }
                        }
                        .disabled(uniqueUpdate)
                }
            } else {
                if edit {
                    TaskTileEditable(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, edit: $edit, isUpdating: $isUpdating, newTask: $newTask, taskTitle: $taskTitle, taskDetail: $taskDetail, taskDeadline: $taskDeadline, taskImportant: $taskImportant, taskColor: $taskColor, taskWeekly: $taskWeekly, taskMonthly: $taskMonthly)
                        .padding(.bottom, 50)
                        .onAppear {
                            taskTitle = ""
                            taskDetail = ""
                            taskDeadline = Date()
                            taskImportant = false
                            taskColor = "NContrast"
                            taskWeekly = false
                            taskMonthly = false
                        }
                    
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("New Task")
                            .font(.system(size: 17, weight: .thin, design: .rounded))
                            .foregroundColor(Color("Contrast").opacity(0.4))
                            .frame(height: 26, alignment: .center)
                        
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
                        withAnimation(.easeInOut(duration: 0.4)) {
                            edit = true
                        }
                    }
                    .padding(25)
                    .frame(width: 320, height: 130, alignment: .topLeading)
                    
                }
            }
        }
#endif
    }
}

struct TaskTile_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NetworkModel())
    }
}
