//
//  TasksView.swift
//  Fuji
//
//  Created by Maximilian Samne on 22.03.23.
//

import SwiftUI

struct TasksView: View {
    
    @AppStorage("user_greeting") var user_greeting: String = ""
    
    @EnvironmentObject var networkModel: NetworkModel
    
#if os(iOS)
    @State private var showTodayTasks: Bool = true
    
    class HapticManager {
        static let instance = HapticManager()
        
        func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
#elseif os(macOS)
    @State var showUpcomingTasks: Bool = true
#endif
    
    @State private var newTask: Bool = false
    
    @Binding var todayTasks: [TaskModel]
    @Binding var upcomingTasks: [TaskModel]
    @Binding var focusTask: TaskModel?
    
    #if os(iOS)
    @Binding var selectedTab: Tabs
    #endif
    
    @Binding var isFetching: Bool
    @Binding var isUpdating: Bool
    
    var body: some View {
#if os(iOS)
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                let currentHour = Calendar.current.dateComponents([.hour], from: Date()).hour
                HStack {
                    if user_greeting != "" {
                        if currentHour! < 12 {
                            Text("Good morning, \(user_greeting).")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        } else if currentHour! >= 12 {
                            Text("Good evening, \(user_greeting).")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        } else {
                            Text("Hello, \(user_greeting).")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        }
                    } else {
                        if currentHour! < 12 {
                            Text("Good morning.")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        } else if currentHour! >= 12 {
                            Text("Good evening.")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        } else {
                            Text("Hello.")
                                .font(.system(.title3, design: .rounded, weight: .light))
                                .padding(.bottom, 16)
                        }
                    }
                }
                .padding(.top, 10)
                .frame(width: UIScreen.sWidth-50)
                .overlay(alignment: .topTrailing) {
                    if !networkModel.connected {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(.callout, design: .rounded, weight: .regular))
                            .foregroundColor(Color("Gray"))
                    }
                }
                
                if showTodayTasks {
                    TodayTaskScroll()
                        .animation(.linear(duration: 0.3), value: showTodayTasks)
                } else {
                    UpcomingTaskScroll()
                        .animation(.linear(duration: 0.3), value: showTodayTasks)
                }
            }
            
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showTodayTasks = true
                        }
                    } label: {
                        Text("Today")
                            .font(showTodayTasks ? .system(.body, design: .rounded, weight: .regular) : .system(.body, design: .rounded, weight: .light))
                            .foregroundColor(showTodayTasks ? Color("Background") : Color("Contrast"))
                            .frame(width: 100, height: 33)
                            .background {
                                if showTodayTasks == true {
                                    Capsule()
                                        .foregroundColor(Color("Contrast"))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showTodayTasks = false
                        }
                    } label: {
                        Text("Upcoming")
                            .font(showTodayTasks ? .system(.body, design: .rounded, weight: .light) : .system(.body, design: .rounded, weight: .regular))
                            .foregroundColor(showTodayTasks ? Color("Contrast") : Color("Background"))
                            .frame(width: 120, height: 33)
                            .background {
                                if showTodayTasks == false {
                                    Capsule()
                                        .foregroundColor(Color("Contrast"))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    
                }
                .padding(.top, 6)
                .frame(width: UIScreen.sWidth)
                .overlay(alignment: .trailing) {
                    Button {
#if os(iOS)
                        HapticManager.instance.impact(style: .light)
#endif
                        newTask.toggle()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showTodayTasks = true
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .padding(.horizontal, 26)
                            .padding(.top, 2)
                    }
                    .disabled(isFetching)
                }
                .background {
                    Color("Background")
                        .ignoresSafeArea()
                }
                
            }
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    if value.translation.width > 0 {
                        // Swiped right
                        withAnimation(.easeInOut(duration: 0.21)) {
                            showTodayTasks.toggle()
                        }
                    } else {
                        // Swiped left
                        withAnimation(.easeInOut(duration: 0.21)) {
                            showTodayTasks.toggle()
                        }
                    }
                }
        )
        
#elseif os(macOS)
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 0) {
                    VStack {
                        HStack {
                            Text("Today")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(Color("Background"))
                                .frame(width: 90, height: 24)
                                .background {
                                    Capsule()
                                        .fill(Color("Contrast"))
                                }
                            
                            if !showUpcomingTasks {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showUpcomingTasks.toggle()
                                    }
                                } label: {
                                    Text("Upcoming")
                                        .font(.system(size: 14, weight: .light, design: .rounded))
                                        .foregroundColor(showUpcomingTasks ? Color("Background") : Color("Contrast"))
                                        .frame(width: 90, height: 24)
                                        .background {
                                            if showUpcomingTasks {
                                                Capsule()
                                                    .fill(Color("Contrast"))
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        TodayTaskScroll()
                    }
                    if showUpcomingTasks {
                        VStack {
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showUpcomingTasks.toggle()
                                }
                            } label: {
                                Text("Upcoming")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundColor(showUpcomingTasks ? Color("Background") : Color("Contrast"))
                                    .frame(width: 90, height: 24)
                                    .background {
                                        if showUpcomingTasks {
                                            Capsule()
                                                .fill(Color("Contrast"))
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                            UpcomingTaskScroll()
                        }
                    }
                }
            }
        }
#endif
    }
    
    
    @ViewBuilder
    func TodayTaskScroll() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(todayTasks) { todayTask in
#if os(iOS)
                    TaskTile(taskModel: todayTask, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, showTodayTasks: $showTodayTasks, selectedTab: $selectedTab, focusTask: $focusTask, isUpdating: $isUpdating, newTask: $newTask)
#elseif os(macOS)
                    TaskTile(taskModel: todayTask, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, isUpdating: $isUpdating, newTask: $newTask)
#endif
                }
            }
        }
    }
    
    @ViewBuilder
    func UpcomingTaskScroll() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(upcomingTasks) { upcomingTask in
#if os(iOS)
                    TaskTile(taskModel: upcomingTask, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, showTodayTasks: $showTodayTasks, selectedTab: $selectedTab, focusTask: $focusTask, isUpdating: $isUpdating, newTask: $newTask)
#elseif os(macOS)
                    TaskTile(taskModel: upcomingTask, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, isUpdating: $isUpdating, newTask: $newTask)
#endif
                }
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NetworkModel())
    }
}
