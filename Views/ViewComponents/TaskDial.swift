//
//  TaskDial.swift
//  Fuji
//
//  Created by Maximilian Samne on 15.04.23.
//

import SwiftUI

struct TaskDial: View {
    
    @AppStorage("user_dial") var user_dial: String = "Yellow"
    @AppStorage("user_dialThinL") var user_dialThinL: Bool = false
    @AppStorage("user_dialThinD") var user_dialThinD: Bool = false
    
    @AppStorage("original_time") var original_time: Double = 1200
    @AppStorage("time_remaining") var time_remaining: Double = 1200
    
    @Environment(\.colorScheme) var colorScheme
    
    
#if os(iOS)
    var lightShadeWidth: CGFloat = UIScreen.sHeight*0.52
    var darkShadeWidth: CGFloat = UIScreen.sHeight*0.47
    var lightShadeHeight: CGFloat = 210
    var darkShadeHeight: CGFloat = 198
    var thinBorderWidth: CGFloat = UIScreen.sHeight*0.403
    var thinBorderHeight: CGFloat = 172
    var innerRectWidth: CGFloat = UIScreen.sHeight*0.40
    var innerRectHeight: CGFloat = 170
    var cornerRadi: CGFloat = 28
#elseif os(macOS)
    var lightShadeWidth: CGFloat = 342
    var darkShadeWidth: CGFloat = 326
    var lightShadeHeight: CGFloat = 148
    var darkShadeHeight: CGFloat = 132
    var thinBorderWidth: CGFloat = 322
    var thinBorderHeight: CGFloat = 132
    var innerRectWidth: CGFloat = 320
    var innerRectHeight: CGFloat = 130
    var cornerRadi: CGFloat = 28
#endif
    
    var body: some View {
        // If i ever want to do opposite progress allowed, then do the if statement here, so simple
        // if reverse_order { timerProgress = (original_time-time_remaining)/original_time, nothing else changes as variables remains the same.
        let timerProgress = time_remaining/original_time
        switch user_dial {
        case "Yellow":
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2"), Color("Yellow3"), Color("Yellow4")]), center: .center))
                            .frame(width: lightShadeWidth, height: lightShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow1"), Color("Yellow1"), Color("Yellow2"), Color("Yellow4"), Color("Yellow5")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    }
                } else {
                    if !user_dialThinD {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2"), Color("Yellow3"), Color("Yellow4")]), center: .center))
                            .frame(width: darkShadeWidth, height: darkShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow1"), Color("Yellow1"), Color("Yellow2"), Color("Yellow4"), Color("Yellow5")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                        
                    }
                }
            }
        case "Green":
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Green2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: lightShadeWidth, height: lightShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Green2")]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    }
                } else {
                    if !user_dialThinD {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Green2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: darkShadeWidth, height: darkShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Green2")]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                        
                    }
                }
            }
        case "Purple":
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Purple6"), Color("Purple7"), Color("Purple8"), Color("Purple1"), Color("Purple2"), Color("Purple2"), Color("Purple3"), Color("Purple4"), Color("Purple5")]), center: .center))
                            .frame(width: lightShadeWidth, height: lightShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Purple3"), Color("Purple5"), Color("Purple6"), Color("Purple7"), Color("Purple1"), Color("Purple2"), Color("Purple2"), Color("Purple2"), Color("Purple3")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    }
                } else {
                    if !user_dialThinD {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Purple6"), Color("Purple7"), Color("Purple8"), Color("Purple1"), Color("Purple2"), Color("Purple2"), Color("Purple3"), Color("Purple4"), Color("Purple5")]), center: .center))
                            .frame(width: darkShadeWidth, height: darkShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Purple3"), Color("Purple5"), Color("Purple6"), Color("Purple7"), Color("Purple1"), Color("Purple2"), Color("Purple2"), Color("Purple2"), Color("Purple3")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                        
                    }
                }
            }
        case "Blue":
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Blue2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: lightShadeWidth, height: lightShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Blue2")]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    }
                } else {
                    if !user_dialThinD {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Blue2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: darkShadeWidth, height: darkShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Blue2")]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                        
                    }
                }
            }
        case "Orange":
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Orange2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: lightShadeWidth, height: lightShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Orange2")]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    }
                } else {
                    if !user_dialThinD {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Orange2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: darkShadeWidth, height: darkShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Orange2")]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                        
                    }
                }
            }
        default:
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2"), Color("Yellow3"), Color("Yellow4")]), center: .center))
                            .frame(width: lightShadeWidth, height: lightShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow1"), Color("Yellow1"), Color("Yellow2"), Color("Yellow4"), Color("Yellow5")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    }
                } else {
                    if !user_dialThinD {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2"), Color("Yellow3"), Color("Yellow4")]), center: .center))
                            .frame(width: darkShadeWidth, height: darkShadeHeight)
#if os(iOS)
                            .blur(radius: 40)
#elseif os(macOS)
                            .blur(radius: 25)
#endif
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow1"), Color("Yellow1"), Color("Yellow2"), Color("Yellow4"), Color("Yellow5")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: thinBorderWidth, height: thinBorderHeight)
                            .animation(.easeInOut(duration: 1), value: timerProgress)
                        
                        RoundedRectangle(cornerRadius: cornerRadi, style: .continuous)
                            .foregroundColor(Color("Background"))
                            .frame(width: innerRectWidth, height: innerRectHeight)
                        
                    }
                }
            }
        }
    }
}

struct TaskDial_Previews: PreviewProvider {
    static var previews: some View {
#if os(iOS)
        DialView(todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "PS 8 andt 9, lecturore yea for sure I really aaa", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), isUpdating: .constant(false), selectedTab: .constant(.dialPage))
#elseif os(macOS)
        DialView(todayTasks: .constant([]), upcomingTasks: .constant([]), focusTask: .constant(TaskModel(userUID: "", taskTitle: "FM300", taskDetail: "PS 8 andt 9, lecturore yea for sure I really aaa", taskDeadline: Date.now, taskImportant: true, taskColor: "NOrange", taskWeekly: false, taskMonthly: true)), isUpdating: .constant(false))
#endif
    }
}
