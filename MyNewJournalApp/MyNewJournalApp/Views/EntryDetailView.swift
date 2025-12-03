//
//  EntryDetailView.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import SwiftUI

struct EntryDetailView: View {
    @EnvironmentObject var viewModel: JournalViewModel
    @Environment(\.dismiss) var dismiss
    let entry: JournalEntry
    
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Date and Mood
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(formatDate(entry.date))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text(formatTime(entry.date))
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Image(systemName: entry.mood.icon)
                                .font(.system(size: 20))
                                .foregroundColor(moodColor)
                            
                            Text(entry.mood.rawValue)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(moodColor)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(moodColor.opacity(0.15))
                        .cornerRadius(20)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Title
                Text(entry.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                // Content
                Text(entry.content)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                    .lineSpacing(8)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Entry Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showEditSheet = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { showDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditEntryView(entry: entry)
                .environmentObject(viewModel)
        }
        .alert("Delete Entry", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteEntry(entry)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        EntryDetailView(
            entry: JournalEntry(
                title: "A Great Day",
                content: "Today was amazing! I finally finished my project and celebrated with friends. The weather was perfect, and everything just fell into place.",
                date: Date(),
                mood: .amazing
            )
        )
    }
    .environmentObject(PreviewHelper.shared.viewModel)
}
