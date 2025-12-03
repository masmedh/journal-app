//
//  MainTabView.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = JournalViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .environmentObject(viewModel)
    }
}

struct ProfileView: View {
    @EnvironmentObject var viewModel: JournalViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Journal User")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text("Keep writing your story")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Statistics")) {
                    StatRow(title: "Total Entries", value: "\(viewModel.totalEntries)")
                    StatRow(title: "Current Streak", value: "\(viewModel.currentStreak) days")
                    StatRow(title: "Overall Mood", value: viewModel.averageMood.rawValue)
                }
                
                Section(header: Text("Settings")) {
                    NavigationLink(destination: Text("Reminders")) {
                        Label("Reminders", systemImage: "bell")
                    }
                    
                    NavigationLink(destination: Text("Themes")) {
                        Label("Themes", systemImage: "paintbrush")
                    }
                    
                    NavigationLink(destination: Text("Privacy")) {
                        Label("Privacy", systemImage: "lock")
                    }
                    
                    NavigationLink(destination: Text("Export Data")) {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: Text("Help & Support")) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink(destination: Text("About")) {
                        Label("About", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    MainTabView()
}
