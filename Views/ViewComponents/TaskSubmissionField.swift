//
//  TaskSubmissionField.swift
//  Fuji
//
//  Created by Maximilian Samne on 11.04.23.
//


import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct TaskSubmissionField: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    
    @EnvironmentObject var networkModel: NetworkModel
    
    let titleTextLimit = 80
    let detailTextLimit = 350
    
    var taskModel: TaskModel
    
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
            
        } else if let range = taskTitle.range(of: " TDAT", options: [.caseInsensitive]) ?? taskTitle.range(of: " day after tomorrow", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else if let range = taskTitle.range(of: "EOW", options: [.caseInsensitive]) ?? taskTitle.range(of: " end of week", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else if let range = taskTitle.range(of: "EOM", options: [.caseInsensitive]) ?? taskTitle.range(of: " end of month", options: [.caseInsensitive]) {
            return taskTitle.replacingCharacters(in: range, with: "")
            
        } else {
            return taskTitle
        }
    }
    
    @FocusState var titleFocused: Bool
    @FocusState var otherFocused: Bool
    
    @State private var uploadErrorMessage: String = ""
    @State private var showUploadError: Bool = false
    
    @Binding var todayTasks: [TaskModel]
    @Binding var upcomingTasks: [TaskModel]
    
    @Binding var edit: Bool
    @Binding var isUpdating: Bool
    @Binding var newTask: Bool
    
    @Binding var taskTitle: String
    @Binding var taskDetail: String
    @Binding var taskDeadline: Date
    @Binding var taskImportant: Bool
    @Binding var taskColor: String
    @Binding var taskWeekly: Bool
    @Binding var taskMonthly: Bool
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
#if os(iOS)
            HStack(alignment: .top) {
                if newTask {
                    TextField("New Task", text: $taskTitle)
                        .font(.system(size: 19, weight: .thin, design: .rounded))
                        .foregroundColor(Color("Contrast"))
                        .textFieldStyle(.plain)
                        .focused($titleFocused)
                        .onChange(of: taskTitle) { _ in
                            limitTitleText(titleTextLimit)
                        }
                } else {
                    TextField(taskModel.taskTitle, text: $taskTitle)
                        .font(.system(size: 19, weight: .thin, design: .rounded))
                        .foregroundColor(Color("Contrast"))
                        .textFieldStyle(.plain)
                        .focused($titleFocused)
                        .onChange(of: taskTitle) { _ in
                            limitTitleText(titleTextLimit)
                        }
                }
            }
            .frame(height: 33, alignment: .topLeading)
            
            HStack {
                if newTask {
                    TextField("Task detail", text: $taskDetail)
                        .font(.system(size: 16, weight: .thin, design: .rounded))
                        .foregroundColor(Color("Contrast"))
                        .textFieldStyle(.plain)
                        .focused($otherFocused)
                        .onChange(of: taskDetail) { _ in
                            limitDetailText(detailTextLimit)
                        }
                } else {
                    TextField(taskModel.taskDetail, text: $taskDetail)
                        .font(.system(size: 16, weight: .thin, design: .rounded))
                        .foregroundColor(Color("Contrast"))
                        .textFieldStyle(.plain)
                        .focused($otherFocused)
                        .onChange(of: taskDetail) { _ in
                            limitDetailText(detailTextLimit)
                        }
                }
            }
            .frame(height: 33, alignment: .topLeading)
#elseif os(macOS)
            HStack(alignment: .top) {
                TextField(taskModel.taskTitle, text: $taskTitle)
                    .font(.system(size: 17, weight: .thin, design: .rounded))
                    .frame(height: 25)
                    .foregroundColor(Color("Contrast"))
                    .textFieldStyle(.plain)
                    .focused($titleFocused)
                    .onChange(of: taskTitle) { _ in
                        limitTitleText(titleTextLimit)
                    }
                
                Spacer()
                
                CreateTask(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, edit: $edit, isUpdating: $isUpdating, newTask: $newTask, taskTitle: $taskTitle, taskDetail: $taskDetail, taskDeadline: $taskDeadline, taskImportant: $taskImportant, taskColor: $taskColor, taskWeekly: $taskWeekly, taskMonthly: $taskMonthly)
                
            }
            .frame(height: 25, alignment: .topTrailing)
            
            
            HStack {
                TextField(taskModel.taskDetail, text: $taskDetail)
                    .font(.system(size: 14.3, weight: .thin, design: .rounded))
                    .foregroundColor(Color("Contrast"))
                    .textFieldStyle(.plain)
                    .focused($otherFocused)
                    .onChange(of: taskDetail) { _ in
                        limitDetailText(detailTextLimit)
                    }
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        taskImportant.toggle()
                    }
                } label: {
                    if taskImportant {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .foregroundColor(Color("Contrast"))
                            .frame(height: 26, alignment: .bottom)
                            .padding(.trailing, 14)
                    } else {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .foregroundColor(Color("Gray"))
                            .frame(height: 26, alignment: .bottom)
                            .padding(.trailing, 14)
                    }
                }
                .buttonStyle(.plain)
            }
            .frame(height: 26, alignment: .center)
#endif
        }
        .onAppear {
            titleFocused = true
        }
#if os(iOS)
        .submitLabel(.done)
#elseif os(macOS)
        .onExitCommand {
            withAnimation(.easeInOut(duration: 0.4)) {
                edit = false
                newTask = false
            }
        }
#endif
        .onSubmit {
            if networkModel.connected && taskTitle != "" && taskTitle != taskModel.taskTitle || taskDetail != taskModel.taskDetail || taskDeadline != taskModel.taskDeadline || taskImportant != taskModel.taskImportant || taskColor != taskModel.taskColor || taskWeekly != taskModel.taskWeekly || taskMonthly != taskModel.taskMonthly {
                updateTask()
            } else {
                withAnimation(.easeInOut(duration: 0.4)) {
                    edit = false
                    newTask = false
                }
            }
        }
        .alert(uploadErrorMessage, isPresented: $showUploadError) {
        }
        
    }
    
    func updateTask() {
        isUpdating = true
        withAnimation(.easeInOut(duration: 0.1)) {
            edit = false
            newTask = false
        }
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
                            print("today->today")
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
                            print("upcoming->today")
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
    
    
    func limitTitleText(_ upper: Int) {
        if taskTitle.count > upper {
            taskTitle = String(taskTitle.prefix(upper))
        }
    }
    
    func limitDetailText(_ upper: Int) {
        if taskDetail.count > upper {
            taskDetail = String(taskDetail.prefix(upper))
        }
    }
}

struct TaskSubmissionField_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NetworkModel())
    }
}
