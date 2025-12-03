//
//  CalendarView.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: JournalViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var showNewEntry = false
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Month Navigation
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text(monthYearString)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Days of Week Header
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(height: 40)
                    }
                }
                .padding(.horizontal)
                .background(Color(.systemBackground))
                
                // Calendar Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(daysInMonth, id: \.self) { date in
                            if let date = date {
                                DayCell(
                                    date: date,
                                    isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                    hasEntry: !viewModel.entriesForDate(date).isEmpty,
                                    isToday: Calendar.current.isDateInToday(date)
                                ) {
                                    selectedDate = date
                                }
                            } else {
                                Color.clear
                                    .frame(height: 60)
                            }
                        }
                    }
                    .padding()
                    
                    // Entries for Selected Date
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(selectedDateString)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            
                            Spacer()
                            
                            Button(action: { showNewEntry = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        let entries = viewModel.entriesForDate(selectedDate)
                        
                        if entries.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: 48))
                                    .foregroundColor(.secondary)
                                
                                Text("No entries for this date")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Button(action: { showNewEntry = true }) {
                                    Text("Create Entry")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            ForEach(entries) { entry in
                                NavigationLink(destination: EntryDetailView(entry: entry)) {
                                    CalendarEntryCard(entry: entry)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showNewEntry) {
            NewEntryView()
                .environmentObject(viewModel)
        }
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var dates: [Date?] = []
        var date = monthFirstWeek.start
        
        let monthEnd = monthInterval.end
        
        while date < monthEnd {
            if Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month) {
                dates.append(date)
            } else {
                dates.append(nil)
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        return dates
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: selectedDate)
    }
    
    private func previousMonth() {
        withAnimation {
            currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation {
            currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasEntry: Bool
    let isToday: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? .white : (isToday ? .blue : .primary))
                
                if hasEntry {
                    Circle()
                        .fill(isSelected ? Color.white : Color.blue)
                        .frame(width: 6, height: 6)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? Color.blue : (isToday ? Color.blue.opacity(0.1) : Color.clear)
            )
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isToday && !isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct CalendarEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: entry.mood.icon)
                .font(.system(size: 24))
                .foregroundColor(moodColor)
                .frame(width: 50, height: 50)
                .background(moodColor.opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(formatTime(entry.date))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Text(entry.content)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var moodColor: Color {
        switch entry.mood {
        case .amazing: return .yellow
        case .happy: return .green
        case .neutral: return .blue
        case .sad: return .indigo
        case .stressed: return .red
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView()
        .environmentObject(JournalViewModel())
}
