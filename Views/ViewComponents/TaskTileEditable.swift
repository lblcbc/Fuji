//
//  TaskTileEditable.swift
//  Fuji
//
//  Created by Maximilian Samne on 25.03.23.
//

#if os(macOS)
import SwiftUI

struct TaskTileEditable: View {
    
    @AppStorage("user_time") var user_time: Int = 12
    @AppStorage("user_morning") var user_morning: Int = 8
    @AppStorage("user_midday") var user_midday: Int = 12
    @AppStorage("user_evening") var user_evening: Int = 18
    @AppStorage("user_night") var user_night: Int = 21
    
    var taskModel: TaskModel
    
    let titleTextLimit = 80
    let detailTextLimit = 350
    
    @FocusState var otherFocused: Bool
    
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
        ZStack {
            let index = todayTasks.firstIndex(where: { task in
                task.id == taskModel.id })
            if index == 0 {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .padding(.horizontal, 8)
                    .foregroundColor(Color("Background"))
                    .shadow(color: Color("Shadow"), radius: 5, y: 3)
            } else {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .foregroundColor(Color("Background"))
            }
            VStack(alignment: .leading, spacing: 0) {
                TaskSubmissionField(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, edit: $edit, isUpdating: $isUpdating, newTask: $newTask, taskTitle: $taskTitle, taskDetail: $taskDetail, taskDeadline: $taskDeadline, taskImportant: $taskImportant, taskColor: $taskColor, taskWeekly: $taskWeekly, taskMonthly: $taskMonthly)
                
                HStack(spacing: 3) {
                    DatePicker("", selection: $taskDeadline, in: Date.now...Date.distantFuture, displayedComponents: .date)
                        .labelsHidden()
                        .foregroundColor(Color("Contrast"))
                        .focused($otherFocused)
                        .frame(width: 130, height: 40, alignment: .leading)
                        .focused($otherFocused)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskDeadline = addWeek(taskDeadline)
                        }
                    } label: {
                        ZStack {
                            Image(systemName: "app")
                                .font(.system(size: 30, weight: .thin, design: .rounded))
                                .foregroundColor(Color("Contrast"))
                            Text("+w")
                                .font(.system(size: 12, weight: .light, design: .rounded))
                                .foregroundColor(Color("Contrast"))
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(width: (320-189)/3, height: 25, alignment: .center)
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskMonthly = false
                            taskWeekly.toggle()
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 16, weight: .light, design: .rounded))
                                .foregroundColor(taskWeekly ? Color("Contrast") : Color("Gray"))
                                .rotationEffect(.degrees(-10))
                            Text("w")
                                .font(.system(size: 12, weight: .light, design: .rounded))
                                .foregroundColor(taskWeekly ? Color("Contrast") : Color("Gray"))
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(width: (320-189)/3, height: 25, alignment: .leading)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskWeekly = false
                            taskMonthly.toggle()
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 16, weight: .light, design: .rounded))
                                .foregroundColor(taskMonthly ? Color("Contrast") : Color("Gray"))
                                .rotationEffect(.degrees(-10))
                            Text("m")
                                .font(.system(size: 12, weight: .light, design: .rounded))
                                .foregroundColor(taskMonthly ? Color("Contrast") : Color("Gray"))
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 2)
                    .frame(width: (320-189)/3, height: 25, alignment: .leading)
                }
                .frame(height: 38, alignment: .leading)
                
                HStack(spacing: 3) {
                    DatePicker("", selection: $taskDeadline, in: Date.now...Date.distantFuture, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .foregroundColor(Color("Contrast"))
                        .focused($otherFocused)
                        .frame(width: 110, height: 40)
                        .padding(.trailing, 8)
                    
                    Spacer()
                    let deadlineHour = Calendar.current.component(.hour, from: taskDeadline)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskDeadline = setToMorning(taskDeadline)
                        }
                    } label: {
                        Image(systemName: "sunrise")
                            .font(deadlineHour == user_morning ? .system(.body, design: .rounded, weight: .regular) : .system(.body, design: .rounded, weight: .light))
                            .foregroundColor(deadlineHour == user_morning ? Color("Contrast") : Color("Gray"))
                            .frame(width: (320-180)/4.4, height: 30, alignment: .center)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskDeadline = setToMidday(taskDeadline)
                        }
                    } label: {
                        Image(systemName: "sun.max")
                            .font(deadlineHour == user_midday ? .system(.body, design: .rounded, weight: .regular) : .system(.body, design: .rounded, weight: .light))
                            .foregroundColor(deadlineHour == user_midday ? Color("Contrast") : Color("Gray"))
                            .frame(width: (320-180)/4.4, height: 30, alignment: .center)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskDeadline = setToEvening(taskDeadline)
                        }
                    } label: {
                        Image(systemName: "sunset")
                            .font(deadlineHour == user_evening ? .system(.body, design: .rounded, weight: .regular) : .system(.body, design: .rounded, weight: .light))
                            .foregroundColor(deadlineHour == user_evening ? Color("Contrast") : Color("Gray"))
                            .frame(width: (320-180)/4.4, height: 30, alignment: .center)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskDeadline = setToNight(taskDeadline)
                        }
                    } label: {
                        Image(systemName: "moon")
                            .font(deadlineHour == user_night ? .system(.subheadline, design: .rounded, weight: .regular) : .system(.subheadline, design: .rounded, weight: .light))
                            .foregroundColor(deadlineHour == user_night ? Color("Contrast") : Color("Gray"))
                            .frame(width: (320-180)/4.4, height: 30, alignment: .center)
                    }
                    .buttonStyle(.plain)
                }
                .frame(height: 38, alignment: .leading)
                
                TaskColorSelector(taskColor: $taskColor)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if otherFocused {
                    otherFocused = false
                }
            }
            .padding(25)
            .frame(width: 320, height: 200, alignment: .topLeading)
        }
        .frame(width: 320, height: 200, alignment: .topLeading)
        .padding(.bottom, 20)
        .onChange(of: taskTitle) { newValue in
            if let _ = taskTitle.range(of: " tomorrow morning", options: [.caseInsensitive]) {
                taskDeadline = getTomorrowMorningDate()
                
            } else if let _ = taskTitle.range(of: " tomorrow midday", options: [.caseInsensitive]) {
                taskDeadline = getTomorrowMiddayDate()
                
            } else if let _ = taskTitle.range(of: " tomorrow evening", options: [.caseInsensitive]) {
                taskDeadline = getTomorrowEveningDate()
                
            } else if let _ = taskTitle.range(of: " tomorrow night", options: [.caseInsensitive]) {
                taskDeadline = getTomorrowNightDate()
                
            } else if let _ = taskTitle.range(of: " tomorrow", options: [.caseInsensitive]) {
                taskDeadline = getTomorrowDate()
                
            } else if let _ = taskTitle.range(of: " TDAT", options: [.caseInsensitive]) {
                taskDeadline = getDayAfterTomorrowDate()
                
            } else if let _ = taskTitle.range(of: " EOW", options: [.caseInsensitive]) ?? taskTitle.range(of: "end of week", options: [.caseInsensitive]) {
                taskDeadline = getEndOfWeekDate()
                
            } else if let _ = taskTitle.range(of: " EOM", options: [.caseInsensitive]) ?? taskTitle.range(of: "end of month", options: [.caseInsensitive]) {
                taskDeadline = getEndOfMonthDate()
            } else {
                taskDeadline = taskDeadline
            }
        }
    }
    
    func setToMorning(_ date: Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(bySettingHour: user_morning, minute: 0, second: 0, of: date)!
        if newDate > Date() {
            return newDate
        } else {
            return Date()
        }
    }
    
    func setToMidday(_ date: Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(bySettingHour: user_midday, minute: 0, second: 0, of: date)!
        if newDate > Date() {
            return newDate
        } else {
            return Date()
        }
        
    }
    
    func setToEvening(_ date: Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(bySettingHour: user_evening, minute: 0, second: 0, of: date)!
        if newDate > Date() {
            return newDate
        } else {
            return Date()
        }
    }
    
    func setToNight(_ date: Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(bySettingHour: user_night, minute: 0, second: 0, of: date)!
        if newDate > Date() {
            return newDate
        } else {
            return Date()
        }
    }
    
    
    func addWeek(_ date: Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .weekOfYear, value: 1, to: date)!
        return newDate
    }
    
    
    func getTomorrowDate() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowNoon = calendar.date(bySettingHour: user_time, minute: 0, second: 0, of: tomorrow)!
        return tomorrowNoon
    }
    
    func getDayAfterTomorrowDate() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 2, to: Date())!
        let tomorrowNoon = calendar.date(bySettingHour: user_time, minute: 0, second: 0, of: tomorrow)!
        return tomorrowNoon
    }
    
    func getTomorrowMorningDate() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowNoon = calendar.date(bySettingHour: user_morning, minute: 0, second: 0, of: tomorrow)!
        return tomorrowNoon
    }
    
    func getTomorrowMiddayDate() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowNoon = calendar.date(bySettingHour: user_midday, minute: 0, second: 0, of: tomorrow)!
        return tomorrowNoon
    }
    
    func getTomorrowEveningDate() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowNoon = calendar.date(bySettingHour: user_evening, minute: 0, second: 0, of: tomorrow)!
        return tomorrowNoon
    }
    
    func getTomorrowNightDate() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowNoon = calendar.date(bySettingHour: user_night, minute: 0, second: 0, of: tomorrow)!
        return tomorrowNoon
    }
    
    func getEndOfWeekDate() -> Date {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        let endOfWeekSunday = calendar.date(bySetting: .weekday, value: 1, of: endOfWeek)!
        let endOfWeekTime = calendar.date(bySettingHour: user_time, minute: 0, second: 0, of: endOfWeekSunday)!
        return endOfWeekTime
    }
    
    func getEndOfMonthDate() -> Date {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        let endOfMonthTime = calendar.date(bySettingHour: user_time, minute: 0, second: 0, of: endOfMonth)!
        return endOfMonthTime
    }
}


struct TaskTileEditable_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NetworkModel())
        
    }
}
#endif
