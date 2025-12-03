//
//  EditEntryView.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import SwiftUI

struct EditEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: JournalViewModel
    
    let entry: JournalEntry
    
    @State private var title: String
    @State private var content: String
    @State private var selectedMood: Mood
    @State private var selectedDate: Date
    @State private var showDatePicker = false
    
    init(entry: JournalEntry) {
        self.entry = entry
        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
        _selectedMood = State(initialValue: entry.mood)
        _selectedDate = State(initialValue: entry.date)
    }
    
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
            .navigationTitle("Edit Entry")
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
        let updatedEntry = JournalEntry(
            id: entry.id,
            title: title,
            content: content,
            date: selectedDate,
            mood: selectedMood
        )
        viewModel.updateEntry(updatedEntry)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    EditEntryView(
        entry: JournalEntry(
            title: "A Great Day",
            content: "Today was amazing!",
            date: Date(),
            mood: .amazing
        )
    )
    .environmentObject(JournalViewModel())
}
