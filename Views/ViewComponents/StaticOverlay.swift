//
//  StaticOverlay.swift
//  Fuji
//
//  Created by Maximilian Samne on 15.04.23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct StaticOverlay: View {
    
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
        if taskModel.taskDetail != "" {
            VStack(spacing: 0) {
                Button {
                    completeTask()
#if os(iOS)
                    HapticManager.instance.impact(style: .medium)
#endif
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color("Contrast"))
#if os(iOS)
                        .frame(width: 17, height: 48, alignment: .leading)
#endif
                        .padding([.horizontal, .top], 25)
#if os(iOS)
                        .padding(.bottom, 5)
#elseif os(macOS)
                        .padding(.bottom, 17)
#endif
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
#if os(iOS)
                Spacer()
                    .frame(height: 14.4)
#elseif os(macOS)
                Spacer()
                    .frame(height: 21.6)
#endif
                
                Button {
#if os(iOS)
                    HapticManager.instance.impact(style: .light)
#endif
                    focusTask = taskModel
#if os(iOS)
                    withAnimation(.easeInOut(duration: 0.4)) {
                        selectedTab = .dialPage
                    }
#elseif os(macOS)
                    Task {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            view_dial = true
                            view_combo = false
                            view_tasks = false
                        }
                    }
#endif
                } label: {
                    ZStack(alignment: .center) {
                        Circle()
                            .foregroundColor(Color(taskModel.taskColor))
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
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                    .padding(.horizontal, 25)
                    .contentShape(Rectangle())
                }
#if os(macOS)
                .buttonStyle(.plain)
#endif
            }
        } else {
            VStack(spacing: 0) {
                Button {
                    completeTask()
#if os(iOS)
                    HapticManager.instance.impact(style: .medium)
#endif
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color("Contrast"))
#if os(iOS)
                        .frame(width: 17, height: 36, alignment: .leading)
#endif
                        .padding([.horizontal, .top], 25)
#if os(iOS)
                        .padding(.top, 14)
#elseif os(macOS)
                        .padding(.bottom, 13)
                        .padding(.top, 6)
#endif
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
#if os(iOS)
                Spacer()
                    .frame(height: 6.02)
#endif
                Button {
#if os(iOS)
                    HapticManager.instance.impact(style: .light)
#endif
                    focusTask = taskModel
#if os(iOS)
                    withAnimation(.easeInOut(duration: 0.4)) {
                        selectedTab = .dialPage
                    }
#elseif os(macOS)
                    Task {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            view_dial = true
                            view_combo = false
                            view_tasks = false
                        }
                    }
#endif
                } label: {
                    ZStack(alignment: .center) {
                        Circle()
                            .foregroundColor(Color(taskModel.taskColor))
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
                    .padding(.top, 22)
                    .padding(.bottom, 22)
                    .padding(.horizontal, 25)
                    .contentShape(Rectangle())
                }
#if os(macOS)
                .buttonStyle(.plain)
#endif
                
            }
        }
    }
    
    func completeTask() {
        isUpdating = true
        uniqueUpdate = true
        user_tasksCompleted += 1
        if taskModel.taskWeekly {
            Task {
                do {
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())
                    let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
                    
                    guard let taskID = taskModel.id else { return }
                    
                    let newTaskDeadline = addWeek(taskModel.taskDeadline)
                    let renewedTaskUpload = TaskModel(userUID: user_UID, taskTitle: taskModel.taskTitle, taskDetail: taskModel.taskDetail, taskDeadline: newTaskDeadline, taskImportant: taskModel.taskImportant, taskColor: taskModel.taskColor, taskWeekly: taskModel.taskWeekly, taskMonthly: taskModel.taskMonthly)
                    
                    let doc = Firestore.firestore().collection("Tasks").document(taskID)
                    
                    let _ = try doc.setData(from: renewedTaskUpload, merge: true, completion: { error in
                        if error == nil {
                            var renewedTask = renewedTaskUpload
                            renewedTask.id = taskID
                            
                            todayTasks.removeAll { renewedTask.id == $0.id }
                            upcomingTasks.removeAll { renewedTask.id == $0.id }
                            
                            if renewedTask.taskDeadline < tomorrow! {
                                todayTasks.removeLast()
                                todayTasks.append(renewedTask)
                                todayTasks.sort {
                                    $0.taskDeadline < $1.taskDeadline
                                }
                                todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
                            } else {
                                upcomingTasks.append(renewedTask)
                                upcomingTasks.sort {
                                    $0.taskDeadline < $1.taskDeadline
                                }
                            }
                            isUpdating = false
                            uniqueUpdate = false
                        }
                    })
                } catch {
                    await setError(error)
                }
            }
        } else if taskModel.taskMonthly {
            Task {
                do {
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())
                    let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
                    
                    guard let taskID = taskModel.id else { return }
                    
                    let newTaskDeadline = addMonth(taskModel.taskDeadline)
                    let renewedTaskUpload = TaskModel(userUID: user_UID, taskTitle: taskModel.taskTitle, taskDetail: taskModel.taskDetail, taskDeadline: newTaskDeadline, taskImportant: taskModel.taskImportant, taskColor: taskModel.taskColor, taskWeekly: taskModel.taskWeekly, taskMonthly: taskModel.taskMonthly)
                    
                    let doc = Firestore.firestore().collection("Tasks").document(taskID)
                    
                    let _ = try doc.setData(from: renewedTaskUpload, merge: true, completion: { error in
                        if error == nil {
                            var renewedTask = renewedTaskUpload
                            renewedTask.id = taskID
                            
                            todayTasks.removeAll { renewedTask.id == $0.id }
                            upcomingTasks.removeAll { renewedTask.id == $0.id }
                            
                            if renewedTask.taskDeadline < tomorrow! {
                                todayTasks.removeLast()
                                todayTasks.append(renewedTask)
                                todayTasks.sort {
                                    $0.taskDeadline < $1.taskDeadline
                                }
                                todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
                            } else {
                                upcomingTasks.append(renewedTask)
                                upcomingTasks.sort {
                                    $0.taskDeadline < $1.taskDeadline
                                }
                            }
                            isUpdating = false
                            uniqueUpdate = false
                        }
                    })
                } catch {
                    await setError(error)
                }
            }
        } else {
            Task {
                do {
                    guard let taskID = taskModel.id else { return }
                    try await Firestore.firestore().collection("Tasks").document(taskID).delete()
                    withAnimation(.easeInOut(duration: 0.3)) {
                        todayTasks.removeAll { taskID == $0.id }
                        upcomingTasks.removeAll { taskID == $0.id }
                    }
                    isUpdating = false
                    uniqueUpdate = false
                } catch {
                    await setError(error)
                }
            }
        }
    }
    
    func addWeek(_ date: Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .weekOfYear, value: 1, to: date)!
        return newDate
    }
    
    func addMonth(_ date: Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: 1, to: date)!
        return newDate
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            completeTaskErrorMessage = error.localizedDescription
            showCompleteTaskError.toggle()
            isUpdating = false
            uniqueUpdate = false
        })
    }
}

struct StaticOverlay_Previews: PreviewProvider {
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
