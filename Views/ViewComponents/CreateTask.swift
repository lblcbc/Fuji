//
//  CreateTask.swift
//  Fuji
//
//  Created by Maximilian Samne on 26.03.23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import RevenueCat

struct CreateTask: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    
    @EnvironmentObject var networkModel: NetworkModel
    
    var taskModel: TaskModel
    
    @Binding var todayTasks: [TaskModel]
    @Binding var upcomingTasks: [TaskModel]
    
    @Binding var edit: Bool
    @Binding var isUpdating: Bool
    
    @Binding var newTask: Bool
    
#if os(iOS)
    @Binding var showTodayTasks: Bool
#endif
    
    @State private var uploadErrorMessage: String = ""
    @State private var showUploadError: Bool = false
    
    @Binding var taskTitle: String
    @Binding var taskDetail: String
    @Binding var taskDeadline: Date
    @Binding var taskImportant: Bool
    @Binding var taskColor: String
    @Binding var taskWeekly: Bool
    @Binding var taskMonthly: Bool
    
#if os(iOS)
    class HapticManager {
        static let instance = HapticManager()
        
        func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
#endif
    
    var updatedTaskTitle: String {
        if let range = taskTitle.range(of: " tomorrow morning", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else if let range = taskTitle.range(of: " tomorrow midday", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else if let range = taskTitle.range(of: " tomorrow evening", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else if let range = taskTitle.range(of: " tomorrow night", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else if let range = taskTitle.range(of: " tomorrow", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else if let range = taskTitle.range(of: " DAT", options: [.caseInsensitive]) ?? taskTitle.range(of: " day after tomorrow", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else if let range = taskTitle.range(of: "EOW", options: [.caseInsensitive]) ?? taskTitle.range(of: " end of week", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else if let range = taskTitle.range(of: "EOM", options: [.caseInsensitive]) ?? taskTitle.range(of: " end of month", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else {
            return taskTitle
        }
    }
    
    var body: some View {
        if taskTitle == taskModel.taskTitle && taskDetail == taskModel.taskDetail && taskDeadline == taskModel.taskDeadline && taskImportant == taskModel.taskImportant && taskColor == taskModel.taskColor && taskWeekly == taskModel.taskWeekly && taskMonthly == taskModel.taskMonthly {
            HStack {
                Button {
#if os(iOS)
                    edit = false
                    newTask = false
#elseif os(macOS)
                    withAnimation(.easeInOut(duration: 0.4)) {
                        edit = false
                        newTask = false
                    }
#endif
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("Contrast"))
                        .font(.system(size: 12, weight: .regular, design: .rounded))
#if os(iOS)
                        .padding(14)
#elseif os(macOS)
                        .padding([.leading, .bottom], 8)
                        .padding(.trailing, 4)
                        .padding(.top, 7)
                        .padding(.bottom, 2)
#endif
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .animation(.easeInOut(duration: 0.3), value: taskTitle != taskModel.taskTitle || taskDetail != taskModel.taskDetail || taskDeadline != taskModel.taskDeadline || taskImportant != taskModel.taskImportant || taskColor != taskModel.taskColor || taskWeekly != taskModel.taskWeekly || taskMonthly != taskModel.taskMonthly)
            }
            .frame(height: 39, alignment: .topLeading)
            .alert(uploadErrorMessage, isPresented: $showUploadError) {
            }
        } else {
            HStack {
                Button {
#if os(iOS)
                    edit = false
                    newTask = false
#elseif os(macOS)
                    withAnimation(.easeInOut(duration: 0.4)) {
                        edit = false
                        newTask = false
                    }
#endif
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("Contrast"))
#if os(iOS)
                        .frame(width: 14, height: 14)
                        .padding(14)
#elseif os(macOS)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .padding([.leading, .bottom], 8)
                        .padding(.top, 7)
                        .padding(.bottom, 8)
#endif
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                
#if os(iOS)
                Spacer()
                    .frame(width: 10)
#endif
                
                Button {
#if os(iOS)
                    HapticManager.instance.impact(style: .medium)
#endif
                    updateTask()
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
#if os(iOS)
                        .frame(width: 30, height: 30)
#elseif os(macOS)
                        .frame(width: 28, height: 28)
#endif
                        .padding(.bottom, 8)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundColor(Color("Contrast"))
                }
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.3), value: taskTitle != taskModel.taskTitle || taskDetail != taskModel.taskDetail || taskDeadline != taskModel.taskDeadline || taskImportant != taskModel.taskImportant || taskColor != taskModel.taskColor || taskWeekly != taskModel.taskWeekly || taskMonthly != taskModel.taskMonthly)
                .disabled(taskTitle == "" || !networkModel.connected)
            }
            .frame(height: 39, alignment: .topLeading)
            .alert(uploadErrorMessage, isPresented: $showUploadError) {
            }
        }
    }
    
    
    func updateTask() {
        isUpdating = true
#if os(iOS)
        edit = false
        newTask = false
#elseif os(macOS)
        withAnimation(.easeInOut(duration: 0.1)) {
            edit = false
            newTask = false
        }
#endif
        Task {
            do {
                if taskModel.id == nil {
                    try await createTaskAtFirebase()
                } else {
                    try await updateTaskAtFirebase()
                }
            } catch {
                await setError(error)
            }
        }
    }
    
    func createTaskAtFirebase() async throws {
        Task {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
            
            let doc = Firestore.firestore().collection("Tasks").document()
            
            let taskUpload = TaskModel(userUID: user_UID, taskTitle: updatedTaskTitle, taskDetail: taskDetail, taskDeadline: taskDeadline, taskImportant: taskImportant, taskColor: taskColor, taskWeekly: taskWeekly, taskMonthly: taskMonthly)
            
            let _ = try doc.setData(from: taskUpload, completion: { error in
                if error == nil {
                    var newTask = taskUpload
                    newTask.id = doc.documentID
                    if newTask.taskDeadline < tomorrow! {
                        todayTasks.removeLast()
                        todayTasks.append(newTask)
                        todayTasks.sort {
                            $0.taskDeadline < $1.taskDeadline
                        }
                        todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
                    } else {
                        upcomingTasks.append(newTask)
                        upcomingTasks.sort {
                            $0.taskDeadline < $1.taskDeadline
                        }
#if os(iOS)
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showTodayTasks = false
                        }
#endif
                    }
                    isUpdating = false
                }
            })
        }
    }
    
    // prefer set merge, so it sets data if data doesn't currently exist
    
    func updateTaskAtFirebase() async throws {
        Task {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
            
            guard let taskID = taskModel.id else { return }
            let doc = Firestore.firestore().collection("Tasks").document(taskID)
            
            let updatedTaskUpload = TaskModel(userUID: user_UID, taskTitle: updatedTaskTitle, taskDetail: taskDetail, taskDeadline: taskDeadline, taskImportant: taskImportant, taskColor: taskColor, taskWeekly: taskWeekly, taskMonthly: taskMonthly)
            
            let _ = try doc.setData(from: updatedTaskUpload, merge: true, completion: { error in
                if error == nil {
                    var updatedTask = updatedTaskUpload
                    updatedTask.id = taskID
                    if updatedTask.taskDeadline < tomorrow! {
                        print("today")
                        if let index = todayTasks.firstIndex(where: { todayTask in
                            todayTask.id == updatedTask.id
                        }) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                todayTasks[index].taskTitle = updatedTask.taskTitle
                                todayTasks[index].taskDetail = updatedTask.taskDetail
                                todayTasks[index].taskDeadline = updatedTask.taskDeadline
                                todayTasks[index].taskImportant = updatedTask.taskImportant
                                todayTasks[index].taskColor = updatedTask.taskColor
                                todayTasks[index].taskWeekly = updatedTask.taskWeekly
                                todayTasks[index].taskMonthly = updatedTask.taskMonthly
                            }
                            todayTasks.removeLast()
                            todayTasks.sort {
                                $0.taskDeadline < $1.taskDeadline
                            }
                            todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                upcomingTasks.removeAll { updatedTask.id == $0.id }
                            }
                            todayTasks.removeLast()
                            todayTasks.append(updatedTask)
                            todayTasks.sort {
                                $0.taskDeadline < $1.taskDeadline
                            }
                            todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
                        }
                    } else {
                        if let index = upcomingTasks.firstIndex(where: { upcomingTask in
                            upcomingTask.id == updatedTask.id
                        }) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                upcomingTasks[index].taskTitle = updatedTask.taskTitle
                                upcomingTasks[index].taskDetail = updatedTask.taskDetail
                                upcomingTasks[index].taskDeadline = updatedTask.taskDeadline
                                upcomingTasks[index].taskImportant = updatedTask.taskImportant
                                upcomingTasks[index].taskColor = updatedTask.taskColor
                                upcomingTasks[index].taskWeekly = updatedTask.taskWeekly
                                upcomingTasks[index].taskMonthly = updatedTask.taskMonthly
                            }
                            upcomingTasks.sort {
                                $0.taskDeadline < $1.taskDeadline
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                todayTasks.removeAll { updatedTask.id == $0.id }
                            }
                            upcomingTasks.append(updatedTask)
                            upcomingTasks.sort {
                                $0.taskDeadline < $1.taskDeadline
                            }
                        }
                    }
                    isUpdating = false
                }
            })
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            uploadErrorMessage = error.localizedDescription
            showUploadError.toggle()
            isUpdating = false
        })
    }
    
}

struct CreateTask_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NetworkModel())
    }
}
