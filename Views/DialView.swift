//
//  DialView.swift
//  Fuji
//
//  Created by Maximilian Samne on 29.03.23.
//

import SwiftUI
import RevenueCat

struct DialView: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_dial") var user_dial: String = "Yellow"
    @AppStorage("user_timeFocused") var user_timeFocused: Double = 0.0
    @AppStorage("original_time") var original_time: Double = 1200
    @AppStorage("time_remaining") var time_remaining: Double = 1200
    @AppStorage("user_dialLight") var user_dialLight: Bool = false
    @AppStorage("user_dialDark") var user_dialDark: Bool = false
    
#if os(macOS)
    @AppStorage("view_tasks") var view_tasks: Bool = false
    @AppStorage("view_dial") var view_dial: Bool = false
    @AppStorage("view_combo") var view_combo: Bool = true
#endif
    
    @EnvironmentObject var userSubscriptionModel: UserSubscriptionModel
    
    @State private var isTimerStarted: Bool = false
    
#if os(macOS)
    @State private var closeHovered: Bool = false
#endif
    
    @Binding var todayTasks: [TaskModel]
    @Binding var upcomingTasks: [TaskModel]
    @Binding var focusTask: TaskModel?
    @Binding var isUpdating: Bool
    
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
            Color("Background")
                .ignoresSafeArea()
            ZStack {
                if focusTask == nil {
                    FocusDials()
                    CountdownMenu(focusTask: $focusTask, isTimerStarted: $isTimerStarted)
                } else {
#if os(iOS)
                    FocusedTask(todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, isUpdating: $isUpdating, isTimerStarted: $isTimerStarted, selectedTab: $selectedTab)
#elseif os(macOS)
                    FocusedTask(todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, focusTask: $focusTask, isUpdating: $isUpdating, isTimerStarted: $isTimerStarted)
#endif
                }
            }
#if os(iOS)
            .padding(.bottom)
#elseif os(macOS)
            .padding(.bottom, 22)
#endif
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
}

struct DialView_Previews: PreviewProvider {
    static var previews: some View {
#if os(iOS)
        DialView(todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "PS 8 andt 9, lecturore yea for sure I really aaa", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), isUpdating: .constant(false), selectedTab: .constant(.dialPage))
#elseif os(macOS)
        DialView(todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "PS 8 andt 9, lecturore yea for sure I really aaa", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), isUpdating: .constant(false))
#endif
    }
}
