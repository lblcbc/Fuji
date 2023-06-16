//
//  CreateTaskSheet.swift
//  Fuji
//
//  Created by Maximilian Samne on 31.03.23.
//

#if os(iOS)
import SwiftUI

struct TaskSheet: View {
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_morning") var user_morning: Int = 8
    @AppStorage("user_midday") var user_midday: Int = 12
    @AppStorage("user_evening") var user_evening: Int = 18
    @AppStorage("user_night") var user_night: Int = 21
    
    var taskModel: TaskModel
    
    @Binding var todayTasks: [TaskModel]
    @Binding var upcomingTasks: [TaskModel]
    
    @Binding var edit: Bool
    @Binding var isUpdating: Bool
    
    @Binding var newTask: Bool
    
    @Binding var showTodayTasks: Bool
    
    @State private var uploadErrorMessage: String = ""
    @State private var showUploadError: Bool = false
    
    @Binding var taskTitle: String
    @Binding var taskDetail: String
    @Binding var taskDeadline: Date
    @Binding var taskImportant: Bool
    @Binding var taskColor: String
    @Binding var taskWeekly: Bool
    @Binding var taskMonthly: Bool
    
    @FocusState var titleFocused: Bool
    @FocusState var otherFocused: Bool
    
    let titleTextLimit = 80
    let detailTextLimit = 350
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 0) {
                    
                    TaskSubmissionField(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, edit: $edit, isUpdating: $isUpdating, newTask: $newTask, taskTitle: $taskTitle, taskDetail: $taskDetail, taskDeadline: $taskDeadline, taskImportant: $taskImportant, taskColor: $taskColor, taskWeekly: $taskWeekly, taskMonthly: $taskMonthly)
                    
                    HStack(spacing: 3) {
                        DatePicker("", selection: $taskDeadline, in: Date.now...Date.distantFuture, displayedComponents: .date)
                            .labelsHidden()
                            .font(.system(.title2, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                            .transformEffect(.init(scaleX: 0.84, y: 0.84))
                            .frame(width: 100, height: 38, alignment: .bottomLeading)
                            .focused($otherFocused)
                        
                        Button {
                            taskDeadline = addWeek(taskDeadline)
                        } label: {
                            ZStack {
                                Image(systemName: "app")
                                    .font(.system(size: 30, weight: .thin, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                                Text("+w")
                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                    .foregroundColor(Color("Contrast"))
                            }
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                        .frame(width: (geo.size.width-189)/3)
                        
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
                        }
                        .buttonStyle(.plain)
                        .frame(width: (geo.size.width-189)/3.6, height: 38, alignment: .center)
                        .contentShape(Rectangle())
                        
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
                        .frame(width: (geo.size.width-189)/3.6, height: 38, alignment: .center)
                        .contentShape(Rectangle())
                    }
                    .frame(height: 38, alignment: .center)
                    
                    HStack(spacing: 3) {
                        DatePicker("", selection: $taskDeadline, in: Date.now...Date.distantFuture, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                            .font(.system(.title2, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                            .transformEffect(.init(scaleX: 0.84, y: 0.84))
                            .frame(width: 130, height: 30, alignment: .leading)
                            .focused($otherFocused)
                        
                        Spacer()
                        let deadlineHour = Calendar.current.component(.hour, from: taskDeadline)
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                taskDeadline = setToMorning(taskDeadline)
                            }
                        } label: {
                            Image(systemName: "sunrise")
                                .font(deadlineHour == user_morning ? .system(.body, design: .rounded, weight: .light) : .system(.body, design: .rounded, weight: .thin))
                                .foregroundColor(deadlineHour == user_morning ? Color("Contrast") : Color("Gray"))
                        }
                        .buttonStyle(.plain)
                        .frame(width: (geo.size.width-180)/5, height: 30, alignment: .center)
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                taskDeadline = setToMidday(taskDeadline)
                            }
                        } label: {
                            Image(systemName: "sun.max")
                                .font(deadlineHour == user_midday ? .system(.body, design: .rounded, weight: .light) : .system(.body, design: .rounded, weight: .thin))
                                .foregroundColor(deadlineHour == user_midday ? Color("Contrast") : Color("Gray"))
                        }
                        .buttonStyle(.plain)
                        .frame(width: (geo.size.width-180)/5, height: 30, alignment: .center)
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                taskDeadline = setToEvening(taskDeadline)
                            }
                        } label: {
                            Image(systemName: "sunset")
                                .font(deadlineHour == user_evening ? .system(.body, design: .rounded, weight: .light) : .system(.body, design: .rounded, weight: .thin))
                                .foregroundColor(deadlineHour == user_evening ? Color("Contrast") : Color("Gray"))
                        }
                        .buttonStyle(.plain)
                        .frame(width: (geo.size.width-180)/5, height: 30, alignment: .center)
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                taskDeadline = setToNight(taskDeadline)
                            }
                        } label: {
                            Image(systemName: "moon")
                                .font(deadlineHour == user_night ? .system(.subheadline, design: .rounded, weight: .light) : .system(.subheadline, design: .rounded, weight: .thin))
                                .foregroundColor(deadlineHour == user_night ? Color("Contrast") : Color("Gray"))
                        }
                        .buttonStyle(.plain)
                        .frame(width: (geo.size.width-180)/5, height: 30, alignment: .center)
                    }
                    .frame(height: 38, alignment: .topLeading)
                    .padding(.bottom, 2)
                    
                    TaskColorSelector(taskColor: $taskColor)
                    
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                taskImportant.toggle()
                            }
                        } label: {
                            Text("Important")
                                .font(taskImportant ? .system(.body, design: .rounded, weight: .semibold) :  .system(.body, design: .rounded, weight: .light))
                                .foregroundColor(taskImportant ? Color("Background") : Color("Gray"))
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .background {
                                    if taskImportant {
                                        Capsule()
                                            .fill(Color("Contrast"))
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                        .frame(width: 200, height: 50, alignment: .center)
                        Spacer()
                    }
                    .overlay(alignment: .bottomTrailing) {
                        CreateTask(taskModel: taskModel, todayTasks: $todayTasks, upcomingTasks: $upcomingTasks, edit: $edit, isUpdating: $isUpdating, newTask: $newTask, showTodayTasks: $showTodayTasks, taskTitle: $taskTitle, taskDetail: $taskDetail, taskDeadline: $taskDeadline, taskImportant: $taskImportant, taskColor: $taskColor, taskWeekly: $taskWeekly, taskMonthly: $taskMonthly)
                    }
                }
                .padding(25)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                .padding(.bottom, 10)
                .padding(.top, 10)
                .onAppear {
                    titleFocused = true
                    otherFocused = true
                }
            }
        }
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
    
    func addDay(_ date: Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: 1, to: date)!
        return newDate
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
    
    func getTomorrowDate() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowNoon = calendar.date(bySettingHour: user_midday, minute: 0, second: 0, of: tomorrow)!
        return tomorrowNoon
    }
    
    func getDayAfterTomorrowDate() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 2, to: Date())!
        let tomorrowNoon = calendar.date(bySettingHour: user_midday, minute: 0, second: 0, of: tomorrow)!
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
        let endOfWeekTime = calendar.date(bySettingHour: user_midday, minute: 0, second: 0, of: endOfWeekSunday)!
        return endOfWeekTime
    }
    
    
    func getEndOfMonthDate() -> Date {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        let endOfMonthTime = calendar.date(bySettingHour: user_midday, minute: 0, second: 0, of: endOfMonth)!
        return endOfMonthTime
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


extension UIScreen{
    static let sWidth = UIScreen.main.bounds.size.width
    static let sHeight = UIScreen.main.bounds.size.height
    static let sSize = UIScreen.main.bounds.size
}


struct TaskSheet_Previews: PreviewProvider {
    static var previews: some View {
        TaskSheet(taskModel: TaskModel(userUID: "", taskTitle: "Sample", taskDetail: "Detail", taskDeadline: Date(), taskImportant: true, taskColor: "NGreen", taskWeekly: true, taskMonthly: false), todayTasks: .constant([]), upcomingTasks: .constant([]), edit: .constant(false), isUpdating: .constant(false), newTask: .constant(false), showTodayTasks: .constant(false), taskTitle: .constant("Task"), taskDetail: .constant("detail"), taskDeadline: .constant(Date()), taskImportant: .constant(true), taskColor: .constant("NGreen"), taskWeekly: .constant(true), taskMonthly: .constant(false))
            .environmentObject(NetworkModel())
    }
}

#endif
