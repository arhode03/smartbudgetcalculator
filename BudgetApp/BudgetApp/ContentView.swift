//
//  ContentView.swift
//  BudgetApp
//
//  Created by Alex Rhodes on 11/9/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                    Text("Welcome to Smart.\nYour Budget Assistant")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(white: 90))
                    
                    
                    
                    // Use NavigationLink directly for navigation
                    NavigationLink(destination: CalculatorView()) {
                        RectangleButton(color: Color.red, title: "New Budget")
                    }
                    NavigationLink(destination: AIView()) {
                        RectangleButton(color: Color.red, title: "Budget Assistant")
                    }
                    
                }
            }
        }
    }
}
struct RectangleButton: View {
    var color: Color
    var title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.black)
            .padding()
            .background(color)
            .cornerRadius(10)
    }
}
