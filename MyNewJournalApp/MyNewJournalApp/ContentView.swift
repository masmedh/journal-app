//
//  ContentView.swift
//  MyNewJournalApp
//
//  Created by Masood Ahamed on 12/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    @State private var showGetStarted = false
    @State private var showMainApp = false
    
    var body: some View {
        if showMainApp {
            MainTabView()
                .transition(.opacity)
        } else {
            landingPageView
        }
    }
    
    var landingPageView: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.2, blue: 0.8),
                    Color(red: 0.2, green: 0.5, blue: 0.9),
                    Color(red: 0.1, green: 0.7, blue: 0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating particles effect
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...80))
                    .position(
                        x: CGFloat.random(in: 0...400),
                        y: isAnimating ? CGFloat.random(in: -100...900) : CGFloat.random(in: 0...800)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 10...20))
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                // App icon/logo
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                        .blur(radius: 10)
                    
                    Image(systemName: "book.pages.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: isAnimating)
                
                // App title
                VStack(spacing: 12) {
                    Text("Journal")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    Text("Your Personal Story")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(2)
                }
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Spacer()
                
                // Features
                VStack(spacing: 20) {
                    FeatureRow(icon: "pencil.and.scribble", title: "Write Your Thoughts", description: "Capture moments that matter")
                    FeatureRow(icon: "calendar", title: "Daily Reflections", description: "Track your journey day by day")
                    FeatureRow(icon: "lock.fill", title: "Private & Secure", description: "Your stories stay yours")
                }
                .opacity(showGetStarted ? 1 : 0)
                .offset(y: showGetStarted ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: showGetStarted)
                
                Spacer()
                
                // Get Started button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showMainApp = true
                    }
                }) {
                    HStack(spacing: 12) {
                        Text("Get Started")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 24))
                    }
                    .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
                    )
                }
                .padding(.horizontal, 40)
                .scaleEffect(showGetStarted ? 1 : 0.9)
                .opacity(showGetStarted ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: showGetStarted)
                
                Spacer()
                    .frame(height: 50)
            }
        }
        .onAppear {
            isAnimating = true
            showGetStarted = true
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    ContentView()
        .environmentObject(PreviewHelper.shared.viewModel)
}
