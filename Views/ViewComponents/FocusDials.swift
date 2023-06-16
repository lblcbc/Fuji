//
//  FocusDials.swift
//  Fuji
//
//  Created by Maximilian Samne on 29.03.23.
//

import SwiftUI

struct FocusDials: View {
    
    @AppStorage("user_dial") var user_dial: String = "Yellow"
    @AppStorage("user_dialThinL") var user_dialThinL: Bool = false
    @AppStorage("user_dialThinD") var user_dialThinD: Bool = false
    
    @AppStorage("original_time") var original_time: Double = 1200
    @AppStorage("time_remaining") var time_remaining: Double = 1200
    
    @Environment(\.colorScheme) var colorScheme
    
    
#if os(iOS)
    var lightShadeSize: CGFloat = UIScreen.sHeight*0.45
    var darkShadeSize: CGFloat = UIScreen.sHeight*0.4
    var thinBorderSize: CGFloat = UIScreen.sHeight*0.35
    var innerCircleSize: CGFloat = UIScreen.sHeight*0.33
#elseif os(macOS)
    var lightShadeSize: CGFloat = 385
    var darkShadeSize: CGFloat = 375
    var thinBorderSize: CGFloat = 350
    var innerCircleSize: CGFloat = 330
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
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2")]), center: .center))
                            .frame(width: lightShadeSize, height: lightShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Yellow2"), Color("Yellow3"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow1"), Color("Yellow1"), Color("Yellow2")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                } else {
                    if !user_dialThinD {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2")]), center: .center))
                            .frame(width: darkShadeSize, height: darkShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Yellow2"), Color("Yellow3"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow1"), Color("Yellow1"), Color("Yellow2")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                }
            }
            .rotationEffect(.degrees(-88))
        case "Green":
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Green2")]), startPoint: .topTrailing, endPoint: .bottomLeading))
                            .frame(width: lightShadeSize, height: lightShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Green2")]), startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                } else {
                    if !user_dialThinD {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Green2")]), startPoint: .topTrailing, endPoint: .bottomLeading))
                            .frame(width: darkShadeSize, height: darkShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Green2")]), startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                }
            }
            .rotationEffect(.degrees(-88))
        case "Purple":
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Purple2"), Color("Purple4"), Color("Purple5"), Color("Purple6"), Color("Purple7"), Color("Purple8"), Color("Purple1"), Color("Purple2"), Color("Purple2")]), center: .center))
                            .frame(width: lightShadeSize, height: lightShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Purple2"), Color("Purple4"), Color("Purple5"), Color("Purple6"), Color("Purple7"), Color("Purple8"), Color("Purple1"), Color("Purple2"), Color("Purple2")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                } else {
                    if !user_dialThinD {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Purple2"), Color("Purple4"), Color("Purple5"), Color("Purple6"), Color("Purple7"), Color("Purple8"), Color("Purple1"), Color("Purple2"), Color("Purple2")]), center: .center))
                            .frame(width: darkShadeSize, height: darkShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Purple2"), Color("Purple4"), Color("Purple5"), Color("Purple6"), Color("Purple7"), Color("Purple8"), Color("Purple1"), Color("Purple2"), Color("Purple2")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                }
            }
            .rotationEffect(.degrees(-88))
        case "Blue":
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Blue2")]), startPoint: .topTrailing, endPoint: .bottomLeading))
                            .frame(width: lightShadeSize, height: lightShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Blue2")]), startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                } else {
                    if !user_dialThinD {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Blue2")]), startPoint: .topTrailing, endPoint: .bottomLeading))
                            .frame(width: darkShadeSize, height: darkShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Blue2")]), startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                }
            }
            .rotationEffect(.degrees(-88))
        case "Orange":
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Orange2")]), startPoint: .topTrailing, endPoint: .bottomLeading))
                            .frame(width: lightShadeSize, height: lightShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Orange2")]), startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                } else {
                    if !user_dialThinD {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Orange2")]), startPoint: .topTrailing, endPoint: .bottomLeading))
                            .frame(width: darkShadeSize, height: darkShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Orange2")]), startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                }
            }
            .rotationEffect(.degrees(-88))
        default:
            ZStack {
                if colorScheme == .light {
                    if !user_dialThinL {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2")]), center: .center))
                            .frame(width: lightShadeSize, height: lightShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow1"), Color("Yellow1"), Color("Yellow2")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                } else {
                    if !user_dialThinD {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow3"), Color("Yellow1"), Color("Yellow2")]), center: .center))
                            .frame(width: darkShadeSize, height: darkShadeSize)
                            .blur(radius: 30)
                            .animation(.linear(duration: 1), value: timerProgress)
                        
                        Circle()
                            .foregroundColor(Color("Background"))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                    } else {
                        Circle()
                            .trim(from: 0, to: timerProgress)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color("Yellow3"), Color("Yellow4"), Color("Yellow5"), Color("Yellow6"), Color("Yellow7"), Color("Yellow8"), Color("Yellow1"), Color("Yellow1"), Color("Yellow2")]), center: .center), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .frame(width: innerCircleSize, height: innerCircleSize)
                            .animation(.linear(duration: 1), value: timerProgress)
                    }
                }
            }
            .rotationEffect(.degrees(-88))
        }
    }
}

struct FocusDials_Previews: PreviewProvider {
    static var previews: some View {
        FocusDials()
    }
}
