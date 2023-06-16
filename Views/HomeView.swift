//
//  HomeView.swift
//  Fuji
//
//  Created by Maximilian Samne on 20.03.23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import RevenueCat

struct HomeView: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("original_time") var original_time: Double = 1200
    @AppStorage("time_remaining") var time_remaining: Double = 1200
    @AppStorage("user_authenticated") var user_authenticated: Bool = false
    
    @EnvironmentObject var networkModel: NetworkModel
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    
#if os(iOS)
    @State private var selectedTab: Tabs = .tasksPage
#endif
    
#if os(macOS)
    @AppStorage("view_tasks") var view_tasks: Bool = false
    @AppStorage("view_dial") var view_dial: Bool = false
    @AppStorage("view_combo") var view_combo: Bool = true
    @State private var viewProfile: Bool = false
#endif
    
    @State var todayTasks: [TaskModel] = []
    @State var upcomingTasks: [TaskModel] = []
    @State private var focusTask: TaskModel?
    @State private var treesFunded: Int = 0
    @State private var showFetchingError: Bool = false
    @State private var isFetching: Bool = false
    @State private var canListen: Bool = false
    @State private var docListener: ListenerRegistration?
    @State var focusDial: Bool = true
    @State var isUpdating: Bool = false
    
    
    var body: some View {
        
#if os(iOS)
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                switch selectedTab {
                case .tasksPage:
                    if user_authenticated {
                        TasksView(todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, selectedTab: $selectedTab, isFetching: $isFetching, isUpdating: $isUpdating)
                    } else {
                        SignInView()
                            .onDisappear {
                                if user_authenticated {
                                    canListen = false
                                    todayTasks = []
                                    upcomingTasks = []
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                        Task {
                                            await fetchTasks()
                                        }
                                    }
                                }
                            }
                    }
                case .dialPage:
                    DialView(todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, isUpdating: $isUpdating, selectedTab: $selectedTab)
                case .profilePage:
                    ProfileView(treesFunded: $treesFunded)
                }
                Spacer()
                VStack {
                    TabBar(selectedTab: $selectedTab)
                }
                .ignoresSafeArea(.keyboard)
            }
        }
        .ignoresSafeArea(.keyboard)
        .task {
            if user_authenticated {
                guard todayTasks.count < 2 && upcomingTasks.isEmpty else { return }
                await fetchTasks()
            }
        }
        .onAppear {
            time_remaining = original_time
            if user_UID != "" && user_authenticated == true {
                listenToTasks()
            }
        }
        .onChange(of: user_authenticated) { _ in
            if user_authenticated == true && docListener == nil {
                print("on change of sign in listener starting")
                listenToTasks()
            } else if user_authenticated == false && docListener != nil {
                docListener!.remove()
                self.docListener = nil
            }
        }
        .sheet(isPresented: $showFetchingError, content: {
            VStack {
                Text("We're having difficulties syncing your tasks. This is usually because: \n\n1. The wifi is unstable \n2. Your account needs to be re-verified (sign out and sign back in again)\n\nDon't worry, your tasks are safe ☺️, and will reappear once the above are solved")
                    .multilineTextAlignment(.leading)
                    .font(.system(.body, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    .padding(.horizontal, 25)
                    .padding(.top, 25)
                
                Spacer()
                
                Button {
                    showFetchingError = false
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(.body, design: .rounded, weight: .regular))
                        .foregroundColor(Color("Contrast"))
                }
            }
            .padding(10)
            .presentationDetents([.height(UIScreen.sHeight*0.38)])
        })
        
        
#elseif os(macOS)
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                MacNavigationMenu(viewProfile: $viewProfile)
                if view_combo {
                    HStack {
                        if !viewProfile {
                            if user_authenticated {
                                TasksView(todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, isFetching: $isFetching, isUpdating: $isUpdating)
                                    .padding(.leading, 14)
                                    .frame(minWidth: 695, maxWidth: 695, minHeight: 500)
                            } else {
                                SignInView()
                                    .frame(minWidth: 695, maxWidth: 695, minHeight: 680)
                                    .onDisappear {
                                        if user_authenticated {
                                            canListen = false
                                            todayTasks = []
                                            upcomingTasks = []
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                                Task {
                                                    await fetchTasks()
                                                }
                                            }
                                        }
                                    }
                            }
                        } else {
                            ProfileView(treesFunded: $treesFunded)
                                .padding(.leading, 14)
                                .frame(minWidth: 695, maxWidth: 695, minHeight: 500, alignment: .leading)
                        }
                        Spacer()
                        DialView(todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, isUpdating: $isUpdating)
                            .frame(minWidth: 590, minHeight: 600)
                    }
                    .frame(minWidth: 1250, minHeight: 680)
                } else if view_tasks {
                    if !viewProfile {
                        if user_authenticated {
                            TasksView(todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, isFetching: $isFetching, isUpdating: $isUpdating)
                                .padding(.leading, 14)
                                .frame(minWidth: 630, maxWidth: 695, minHeight: 180)
                        } else {
                            SignInView()
                                .padding(.leading, 14)
                                .frame(minWidth: 630, maxWidth: 695, minHeight: 680)
                                .onDisappear {
                                    if user_authenticated {
                                        canListen = false
                                        todayTasks = []
                                        upcomingTasks = []
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                            Task {
                                                await fetchTasks()
                                            }
                                        }
                                    }
                                }
                        }
                    } else {
                        ProfileView(treesFunded: $treesFunded)
                            .frame(minWidth: 630, maxWidth: 695, minHeight: 500)
                    }
                } else if view_dial {
                    if !viewProfile {
                        DialView(todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, isUpdating: $isUpdating)
                            .frame(minWidth: 500, minHeight: 500)
                    } else {
                        ProfileView(treesFunded: $treesFunded)
                            .frame(minWidth: 500, maxWidth: 695, minHeight: 500)
                    }
                }
            }
        }
        .task {
            if user_authenticated {
                guard todayTasks.count < 2 && upcomingTasks.isEmpty else { return }
                await fetchTasks()
            }
        }
        .onAppear {
            time_remaining = original_time
            if user_UID != "" && user_authenticated == true && docListener == nil {
                print("on appear listener starting")
                listenToTasks()
            }
        }
        .onChange(of: user_authenticated) { _ in
            if user_authenticated == true && docListener == nil {
                print("on change of sign in listener starting")
                listenToTasks()
            } else if user_authenticated == false && docListener != nil {
                docListener!.remove()
                self.docListener = nil
            }
        }
        .sheet(isPresented: $showFetchingError, content: {
            VStack {
                Text("We're having difficulties syncing your tasks. This is usually because: \n\n1. The wifi is unstable \n2. Your account needs to be re-verified (sign out and sign back in again)\n\nDon't worry, your tasks are safe ☺️, and will reappear once the above are solved")
                    .multilineTextAlignment(.leading)
                    .font(.system(.body, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    .padding(.horizontal, 25)
                    .padding(.top, 25)
                
                Spacer()
                
                Button {
                    showFetchingError = false
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(.body, design: .rounded, weight: .regular))
                        .foregroundColor(Color("Contrast"))
                }
            }
        })
#endif
    }
    
    func fetchTasks() async {
        guard networkModel.connected else { return }
        do {
            isFetching = true
            var query: Query!
            print("FetchTasks - TASK VIEW: Fetch var defined")
            
            query = Firestore.firestore().collection("Tasks").whereField("userUID", isEqualTo: user_UID)
            
            let fetchedTasks = try await query.getDocuments().documents.compactMap { fetchedTaskTile -> TaskModel? in try? fetchedTaskTile.data(as: TaskModel.self)
            }
            
            let sortedFetchedTasks = fetchedTasks.sorted {
                $0.taskDeadline < $1.taskDeadline
            }
            
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
            
            let todayFetchedTasks = sortedFetchedTasks.filter {
                $0.taskDeadline < tomorrow!
            }
            
            let upcomingFetchedTasks = sortedFetchedTasks.filter {
                $0.taskDeadline >= tomorrow!
            }
            
            await MainActor.run(body: {
                todayTasks = []
                upcomingTasks = []
                withAnimation(.easeInOut(duration: 0.5)) {
                    todayTasks.append(contentsOf: todayFetchedTasks)
                    todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
                    
                    upcomingTasks.append(contentsOf: upcomingFetchedTasks)
                }
                isFetching = false
                canListen = true
            })
        } catch {
            withAnimation(.easeInOut(duration: 0.3)) {
                todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
            }
            await setError(error)
            print(error.localizedDescription)
            isFetching = false
        }
    }
    
    func listenToTasks() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)
        
        docListener = Firestore.firestore().collection("Tasks").whereField("userUID", isEqualTo: user_UID).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                return
            }
            snapshot.documentChanges.forEach { diff in
                if canListen && !isUpdating {
                    if (diff.type == .added) {
                        if canListen {
                            print("canListen doc added")
                            if let newTask = try? diff.document.data(as: TaskModel.self) {
                                if newTask.taskDeadline < tomorrow! {
                                    if !todayTasks.isEmpty {
                                        todayTasks.removeLast()
                                    }
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
                            }
                        }
                    }
                    if (diff.type == .modified) {
                        print("canListen doc modified")
                        if let updatedTask = try? diff.document.data(as: TaskModel.self) {
                            if updatedTask.taskDeadline < tomorrow! {
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
                                    if !todayTasks.isEmpty {
                                        todayTasks.removeLast()
                                    }
                                    todayTasks.sort {
                                        $0.taskDeadline < $1.taskDeadline
                                    }
                                    todayTasks.append(TaskModel(userUID: "", taskTitle: "New Task", taskDetail: "Detail", taskDeadline: Date(), taskImportant: false, taskColor: "NContrast", taskWeekly: false, taskMonthly: false))
                                } else if let _ = upcomingTasks.firstIndex(where: { upcomingTask in
                                    upcomingTask.id == updatedTask.id
                                }) {
                                    upcomingTasks.removeAll { updatedTask.id == $0.id }
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
                                } else if let _ = todayTasks.firstIndex(where: { todayTask in
                                    todayTask.id == updatedTask.id
                                }) {
                                    todayTasks.removeAll { updatedTask.id == $0.id }
                                    upcomingTasks.append(updatedTask)
                                    upcomingTasks.sort {
                                        $0.taskDeadline < $1.taskDeadline
                                    }
                                }
                            }
                        }
                    }
                    if (diff.type == .removed) {
                        print("canListen doc deleted")
                        if let deletedTask = try? diff.document.data(as: TaskModel.self) {
                            todayTasks.removeAll { deletedTask.id == $0.id }
                            upcomingTasks.removeAll { deletedTask.id == $0.id }
                        }
                    }
                }
            }
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            showFetchingError.toggle()
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NetworkModel())
    }
}
