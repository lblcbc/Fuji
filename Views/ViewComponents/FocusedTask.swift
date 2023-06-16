//
//  FocusedTask.swift
//  Fuji
//
//  Created by Maximilian Samne on 15.04.23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import AudioToolbox


struct FocusedTask: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_dial") var user_dial: String = "Yellow"
    @AppStorage("original_time") var original_time: Double = 1200
    @AppStorage("time_remaining") var time_remaining: Double = 1200
    @AppStorage("user_timeFocused") var user_timeFocused: Double = 0.0
    @AppStorage("user_tasksCompleted") var user_tasksCompleted: Int = 0
    @AppStorage("user_dialLight") var user_dialLight: Bool = false
    @AppStorage("user_dialDark") var user_dialDark: Bool = false
    
#if os(macOS)
    @AppStorage("view_tasks") var view_tasks: Bool = false
    @AppStorage("view_dial") var view_dial: Bool = false
    @AppStorage("view_combo") var view_combo: Bool = true
#endif
    
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    
    @State private var showTimerOptions: Bool = false
    @State private var completeTaskErrorMessage: String = ""
    @State private var showCompleteTaskError: Bool = false
    
#if os(macOS)
    @State private var closeHovered: Bool = false
    @State private var completeHovered: Bool = false
#endif
    
    @Binding var todayTasks: [TaskModel]
    @Binding var upcomingTasks: [TaskModel]
    @Binding var focusTask: TaskModel?
    @Binding var isUpdating: Bool
    @Binding var isTimerStarted: Bool
    
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
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            ZStack {
                TaskDial()
                FocusTaskTile(focusTask: $focusTask)
                
            }
            .padding(.vertical, 50)
            
            
            CountdownMenu(focusTask: $focusTask, isTimerStarted: $isTimerStarted)
#if os(iOS)
                .padding(.top, 25)
#endif
            
            Spacer()
            
#if os(iOS)
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        selectedTab = .tasksPage
                        isTimerStarted = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            focusTask = nil
                        }
                    }
                } label: {
                    Text("Close")
                        .font(.system(.body, design: .rounded, weight: .thin))
                        .foregroundColor(Color("Contrast"))
                        .frame(width: 80, height: 30)
                        .contentShape(Rectangle())
                }
                .disabled(isUpdating)
                
                Button {
                    completeTask()
                } label: {
                    Text("Complete")
                        .foregroundColor(Color("Contrast"))
                        .font(.system(.body, design: .rounded, weight: .light))
                        .frame(width: 100, height: 30)
                        .contentShape(Rectangle())
                }
                .disabled(isUpdating)
                
            }
            
            
#elseif os(macOS)
            HStack {
                Button {
                    Task {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            isTimerStarted = false
                            view_tasks = true
                            view_dial = false
                            view_combo = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                focusTask = nil
                            }
                        }
                    }
                } label: {
                    Text("Close")
                        .font(closeHovered ? .system(.body, design: .rounded, weight: .light) : .system(.body, design: .rounded, weight: .thin))
                        .foregroundColor(Color("Contrast"))
                        .frame(width: 80, height: 26)
                }
                .buttonStyle(.plain)
                .disabled(isUpdating)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        closeHovered = hovering
                    }
                }
                
                ZStack {
                    if completeHovered {
                        Button {
                            completeTask()
                        } label: {
                            Text("Complete")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .foregroundColor(Color("Background"))
                                .frame(width: 90, height: 26)
                                .background {
                                    Capsule()
                                        .fill(Color("Contrast"))
                                }
                        }
                        .buttonStyle(.plain)
                        .disabled(isUpdating)
                    } else {
                        Button { } label: {
                            Text("Complete")
                                .font(.system(.title3, design: .rounded, weight: .thin))
                                .foregroundColor(Color("Contrast"))
                                .frame(width: 90, height: 26)
                        }
                        .buttonStyle(.plain)
                        .disabled(isUpdating)
                    }
                }
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        completeHovered = hovering
                    }
                }
            }
#endif
        }
#if os(iOS)
        .padding(25)
        .frame(width: UIScreen.sWidth)
#endif
        .overlay(alignment: .topTrailing) {
            VStack(alignment: .trailing, spacing: 0) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showTimerOptions.toggle()
                    }
                } label: {
                    Image(systemName: "circle.dotted")
                        .font(.system(.title3, design: .rounded, weight: .light))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 25)
                .padding(.bottom, 20)
                .contentShape(Rectangle())
                
                if showTimerOptions {
                    DialColorSelector()
                        .padding(.trailing, 25)
                }
            }
        }
#if os(iOS)
        .onChange(of: isTimerStarted) { _ in
            if isTimerStarted {
                UIApplication.shared.isIdleTimerDisabled = true
            } else {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
#endif
    }
    
    
    func completeTask() {
        guard focusTask != nil else {
            isTimerStarted = false
            return
        }
        isUpdating = true
        user_tasksCompleted += 1
        if focusTask!.taskWeekly {
            Task {
                do {
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())
                    let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
                    
                    guard let taskID = focusTask!.id else { return }
                    
                    let newTaskDeadline = addWeek(focusTask!.taskDeadline)
                    let renewedTaskUpload = TaskModel(userUID: user_UID, taskTitle: focusTask!.taskTitle, taskDetail: focusTask!.taskDetail, taskDeadline: newTaskDeadline, taskImportant: focusTask!.taskImportant, taskColor: focusTask!.taskColor, taskWeekly: focusTask!.taskWeekly, taskMonthly: focusTask!.taskMonthly)
                    
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
#if os(iOS)
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isTimerStarted = false
                                selectedTab = .tasksPage
                            }
#elseif os(macOS)
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isTimerStarted = false
                                view_tasks = true
                                view_dial = false
                                view_combo = false
                            }
#endif
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                focusTask = nil
                            }
                        }
                    })
                } catch {
                    await setError(error)
                }
            }
        } else if focusTask!.taskMonthly {
            Task {
                do {
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())
                    let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
                    
                    guard let taskID = focusTask!.id else { return }
                    
                    let newTaskDeadline = addMonth(focusTask!.taskDeadline)
                    let renewedTaskUpload = TaskModel(userUID: user_UID, taskTitle: focusTask!.taskTitle, taskDetail: focusTask!.taskDetail, taskDeadline: newTaskDeadline, taskImportant: focusTask!.taskImportant, taskColor: focusTask!.taskColor, taskWeekly: focusTask!.taskWeekly, taskMonthly: focusTask!.taskMonthly)
                    
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
#if os(iOS)
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isTimerStarted = false
                                selectedTab = .tasksPage
                            }
                            
#elseif os(macOS)
                            withAnimation(.easeInOut(duration: 0.4)) {
                                isTimerStarted = false
                                view_tasks = true
                                view_dial = false
                                view_combo = false
                            }
#endif
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                focusTask = nil
                            }
                        }
                    })
                } catch {
                    await setError(error)
                }
            }
        } else {
            Task {
                do {
                    guard let taskID = focusTask!.id else { return }
                    try await Firestore.firestore().collection("Tasks").document(taskID).delete()
                    withAnimation(.easeInOut(duration: 0.3)) {
                        todayTasks.removeAll { taskID == $0.id }
                        upcomingTasks.removeAll { taskID == $0.id }
                    }
                    isUpdating = false
#if os(iOS)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isTimerStarted = false
                        selectedTab = .tasksPage
                    }
#elseif os(macOS)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isTimerStarted = false
                        view_tasks = true
                        view_dial = false
                        view_combo = false
                    }
#endif
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        focusTask = nil
                    }
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
#if os(iOS)
            withAnimation(.easeInOut(duration: 0.3)) {
                isTimerStarted = false
                selectedTab = .tasksPage
            }
#elseif os(macOS)
            withAnimation(.easeInOut(duration: 0.3)) {
                isTimerStarted = false
                view_tasks = true
                view_dial = false
                view_combo = false
            }
#endif
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                focusTask = nil
            }
        })
    }
}

struct FocusedTask_Previews: PreviewProvider {
    static var previews: some View {
#if os(iOS)
        DialView(todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "Problem set 9 and 10", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), isUpdating: .constant(false), selectedTab: .constant(.dialPage))
#elseif os(macOS)
        DialView(todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "Problem set 9 and 10", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), isUpdating: .constant(false))
#endif
    }
}
