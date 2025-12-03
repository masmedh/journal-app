//
//  NewEntryView.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import SwiftUI

struct NewEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: JournalViewModel
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedMood: Mood = .neutral
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Date Picker
                    Button(action: { showDatePicker.toggle() }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text(formatDate(selectedDate))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                                .rotationEffect(.degrees(showDatePicker ? 180 : 0))
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    if showDatePicker {
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .scale))
                    }
                    
                    // Mood Selector
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How are you feeling?")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Mood.allCases, id: \.self) { mood in
                                    MoodButton(mood: mood, isSelected: selectedMood == mood) {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedMood = mood
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Title Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.horizontal)
                        
                        TextField("Give your entry a title", text: $title)
                            .font(.system(size: 17))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // Content Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Journal Entry")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.horizontal)
                        
                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Write your thoughts here...")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                            }
                            
                            TextEditor(text: $content)
                                .font(.system(size: 16))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .scrollContentBackground(.hidden)
                                .scrollDisabled(true)
                                .frame(height: 250)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
    
    private func saveEntry() {
        let entry = JournalEntry(
            title: title,
            content: content,
            date: selectedDate,
            mood: selectedMood
        )
        viewModel.addEntry(entry)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mood.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .white : moodColor)
                
                Text(mood.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(
                isSelected ? moodColor : Color(.systemGray6)
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(moodColor, lineWidth: isSelected ? 0 : 2)
            )
        }
    }
    
    private var moodColor: Color {
        switch mood {
        case .amazing: return .yellow
        case .happy: return .green
        case .neutral: return .blue
        case .sad: return .indigo
        case .stressed: return .red
        }
    }
}

#Preview {
    NewEntryView()
        .environmentObject(JournalViewModel())
}
