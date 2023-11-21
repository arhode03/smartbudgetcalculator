//
//  ContentView.swift
//  BudgetApp
//
//  Created by Alex Rhodes and Nicholas Mollica on 11/9/23.
//

import SwiftUI

struct ContentView: View {
       @State private var monthlyIncome = 0.0
       @State private var variableCosts = 0.0
       @State private var fixedCosts = 0.0
       @State private var variableremainingIncome = 0.0
       @State private var taxAmount = 0.0
       @State private var v_expenses: [Expense] = []
       @State private var expenses: [Expense] = []
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {               //creates main menu
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
struct RectangleButton: View {                 //creates rectangle button
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
