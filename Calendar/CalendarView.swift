//
//  CalendarView.swift
//  Calendar
//
//  Created by Nick on 26.06.2023.
//

import SwiftUI

struct CalendarView: View {
    // MARK: - PROPERTIES
    @StateObject var vm = CalendarViewModel()
    
    // MARK: - BODY
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                HStack {
                    Text(vm.dateToStr(vm.firstDate ?? Date()))
                        .font(.system(size: 20, weight: .medium))
                    Text(" - ")
                        .font(.system(size: 20, weight: .medium))
                    Text(vm.dateToStr(vm.secondDate ?? Date()))
                        .font(.system(size: 20, weight: .medium))
                }
                .foregroundColor(Color.white)
                VStack(spacing: 8) {
                    HStack {
                        HStack {
                            Button(action: {
                                vm.selectBackMonth()
                            }) {
                                Image(systemName: "arrow.left")
                                    .frame(width: 30, height: 30)
                            }
                            .buttonStyle(.plain)
                            .padding(.leading, 10)
                            Text(vm.titleForMonth())
                                .font(.system(size: 16, weight: .semibold))
                                .frame(width: 100)
                            Button(action: {
                                vm.selectForwardMonth()
                            }) {
                                Image(systemName: "arrow.right")
                                    .frame(width: 30, height: 30)
                            }
                            .buttonStyle(.plain)
                            .padding(.trailing, 10)
                        }
                        
                        HStack {
                            Button(action: {
                                vm.selectBackYear()
                            }) {
                                Image(systemName: "arrow.left")
                                    .frame(width: 30, height: 30)
                            }
                            .buttonStyle(.plain)
                            .padding(.leading, 10)
                            Text(vm.titleForYear())
                                .font(.system(size: 16, weight: .semibold))
                                .frame(width: 45)
                            Button(action: {
                                vm.selectForwardYear()
                            }) {
                                Image(systemName: "arrow.right")
                                    .frame(width: 30, height: 30)
                            }
                            .buttonStyle(.plain)
                            .padding(.trailing, 10)
                        }
                    }
                    .foregroundColor(Color.white)
                    
                    VStack(spacing: 3) {
                        HStack(spacing: 0) {
                            ForEach(vm.days, id: \.self) { day in
                                Text("\(day)")
                                    .frame(height: 36)
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 12, weight: .bold))
                            }
                        }
                        .foregroundColor(Color.white)
                        
                        VStack(spacing: 6) {
                            ForEach(vm.weeks, id: \.self) { week in
                                ZStack {
                                    HStack(spacing: 0) {
                                        ForEach(Array(week.enumerated()), id: \.offset) { index, day in
                                            if vm.calendar.isDate(day, equalTo: vm.date, toGranularity: .month) {
                                                ZStack {
                                                    fillRange(day: day, week: week, index: index)
                                                    Button(action: {
                                                        vm.selectDay(day)
                                                    }) {
                                                        ZStack {
                                                            Text("\(vm.calendar.component(.day, from: day))")
                                                                .font(.system(size: 12, weight: .regular))
                                                                .foregroundColor(vm.isDateSelected(day: day) ? Color.black : Color.white)
                                                            Circle()
                                                                .frame(width: 4, height: 4)
                                                                .foregroundColor(vm.isToday(day: day) ? (vm.isDateSelected(day: day) ? Color.black : Color.white) : Color.clear)
                                                                .offset(y: 12)
                                                        }
                                                        .frame(width: 36, height: 36)
                                                        .contentShape(Rectangle())
                                                    }
                                                    .buttonStyle(.plain)
                                                    .background(vm.isDateInRange(day: day) ? (vm.isDateSelected(day: day) ? Color.white.cornerRadius(4) : Color.black.cornerRadius(4)) : Color.clear.cornerRadius(4))
                                                }
                                                .frame(height: 36)
                                                .frame(maxWidth: .infinity)
                                            } else {
                                                Rectangle()
                                                    .foregroundColor(Color.clear)
                                                    .frame(height: 36)
                                                    .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - VARS
    @ViewBuilder
    func fillRange(day: Date, week: [Date], index: Int) -> some View {
        HStack(spacing: 0) {
            if vm.isDateSelected(day: day) {
                if day == vm.firstDate {
                    Color.clear
                } else {
                    Color.black
                }
            } else {
                if vm.isDateInRange(day: day) {
                    if index == 0 {
                        Color.clear
                    } else {
                        if vm.isFirstDayOfMonth(date: day) {
                            Color.clear
                        } else {
                            Color.black
                        }
                    }
                } else {
                    Color.clear
                }
            }
            
            if vm.isDateSelected(day: day) {
                if day == vm.secondDate {
                    Color.clear
                } else {
                    if vm.secondDate == nil {
                        Color.clear
                    } else {
                        Color.black
                    }
                }
            } else {
                if vm.isDateInRange(day: day) {
                    if index == week.count - 1 {
                        Color.clear
                    } else {
                        if vm.isLastDayOfMonth(date: day) {
                            Color.clear
                        } else {
                            Color.black
                        }
                    }
                } else {
                    Color.clear
                }
            }
        }
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
