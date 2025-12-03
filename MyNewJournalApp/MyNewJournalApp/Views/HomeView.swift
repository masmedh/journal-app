//
//  HomeView.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: JournalViewModel
    @State private var showNewEntry = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(formattedDate)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Summary Cards
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            SummaryCard(
                                title: "Total Entries",
                                value: "\(viewModel.totalEntries)",
                                icon: "book.fill",
                                color: .blue
                            )
                            
                            SummaryCard(
                                title: "Current Streak",
                                value: "\(viewModel.currentStreak)",
                                icon: "flame.fill",
                                color: .orange
                            )
                        }
                        
                        SummaryCard(
                            title: "Overall Mood",
                            value: viewModel.averageMood.rawValue,
                            icon: viewModel.averageMood.icon,
                            color: moodColor(viewModel.averageMood),
                            isWide: true
                        )
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Actions")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.horizontal)
                        
                        Button(action: { showNewEntry = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                Text("Write New Entry")
                                    .font(.system(size: 17, weight: .semibold))
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    
                    // Recent Entries
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Entries")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.horizontal)
                        
                        if viewModel.entries.isEmpty {
                            EmptyStateView()
                        } else {
                            ForEach(viewModel.entries.prefix(5)) { entry in
                                NavigationLink(destination: EntryDetailView(entry: entry)) {
                                    EntryRowView(entry: entry)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .scrollIndicators(.visible)
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showNewEntry) {
            NewEntryView()
                .environmentObject(viewModel)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
    
    private func moodColor(_ mood: Mood) -> Color {
        switch mood {
        case .amazing: return .yellow
        case .happy: return .green
        case .neutral: return .blue
        case .sad: return .indigo
        case .stressed: return .red
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var isWide: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: isWide ? .infinity : nil)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct EntryRowView: View {
    let entry: JournalEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Mood icon
            Image(systemName: entry.mood.icon)
                .font(.system(size: 24))
                .foregroundColor(moodColor(entry.mood))
                .frame(width: 50, height: 50)
                .background(moodColor(entry.mood).opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(entry.content)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(formatDate(entry.date))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func moodColor(_ mood: Mood) -> Color {
        switch mood {
        case .amazing: return .yellow
        case .happy: return .green
        case .neutral: return .blue
        case .sad: return .indigo
        case .stressed: return .red
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No entries yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("Start writing your first journal entry")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
        .environmentObject(PreviewHelper.shared.viewModel)
}
