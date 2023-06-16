//
//  TimeDefaultsSelector.swift
//  Fuji
//
//  Created by Maximilian Samne on 10.04.23.
//

import SwiftUI

struct TimeDefaultsSelector: View {
    
    @AppStorage("user_morning") var user_morning: Int = 8
    @AppStorage("user_midday") var user_midday: Int = 12
    @AppStorage("user_evening") var user_evening: Int = 18
    @AppStorage("user_night") var user_night: Int = 21
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
#if os(macOS)
                        Text("Morning ")
#endif
                        Image(systemName: "sunrise")
                    }
                    .font(.system(.subheadline, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    
                    HStack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_morning = 7
                            }
                        } label: {
                            Text("7")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_morning == 7 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_morning = 8
                            }
                        } label: {
                            Text("8")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_morning == 8 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_morning = 9
                            }
                        } label: {
                            Text("9")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_morning == 9 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                    }
                }
                .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
#if os(macOS)
                        Text("Midday ")
#endif
                        Image(systemName: "sun.max")
                    }
                    .font(.system(.subheadline, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    
                    HStack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_midday = 11
                            }
                        } label: {
                            Text("11")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_midday == 11 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_midday = 12
                            }
                        } label: {
                            Text("12")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_midday == 12 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_midday = 13
                            }
                        } label: {
                            Text("13")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_midday == 13 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                    }
                }
                .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
#if os(macOS)
                        Text("Evening ")
#endif
                        Image(systemName: "sunset")
                    }
                    .font(.system(.subheadline, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    
                    HStack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_evening = 17
                            }
                        } label: {
                            Text("17")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_evening == 17 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_evening = 18
                            }
                        } label: {
                            Text("18")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_evening == 18 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_evening = 19
                            }
                        } label: {
                            Text("19")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_evening == 19 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                    }
                }
                .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
#if os(macOS)
                        Text("Night ")
#endif
                        Image(systemName: "moon")
                            .font(.system(.caption, design: .rounded, weight: .light))
                    }
                    .font(.system(.subheadline, design: .rounded, weight: .light))
                    .foregroundColor(Color("Contrast"))
                    
                    HStack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_night = 20
                            }
                        } label: {
                            Text("20")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_night == 20 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_night = 21
                            }
                        } label: {
                            Text("21")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_night == 21 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                user_night = 22
                            }
                        } label: {
                            Text("22")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundColor(user_night == 22 ? Color("Contrast") : Color("Gray"))
                        }
                        .padding(4)
                        .contentShape(Rectangle())
                        
                    }
                }
                .padding(.trailing, 10)
                
            }
        }
    }
}

struct TimeDefaultsSelector_Previews: PreviewProvider {
    static var previews: some View {
        TimeDefaultsSelector()
    }
}
