//
//  CalculatorView.swift
//  BudgetApp
//
//  Created by Alex Rhodes on 11/9/23.
//

import Foundation
import SwiftUI

struct CalculatorView: View {
    @State private var monthlyIncome: Double = 0.0
    @State private var expenses: [Expense] = []
    var fixedcost: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Enter your monthly Income")
                    .font(.headline)
                    .padding()
                
                TextField("Enter monthly income", value: $monthlyIncome, formatter: createCurrencyFormatter(), onCommit: {
                    // Do nothing or perform any additional actions you need
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                Text("Fixed Expenses")
                
                ForEach(expenses.indices, id: \.self) { index in
                    HStack {
                        TextField("Enter expense", value: self.$expenses[index].amount, formatter: createCurrencyFormatter(), onCommit: {
                            // Parse the input and perform any necessary operations
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        
                        TextField("Expense label", text: self.$expenses[index].label, onCommit: {
                            // Do nothing or perform any additional actions you need
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    }
                }
                
                Button(action: {
                    self.expenses.append(Expense(amount: 0.0, label: ""))
                }) {
                    Text("Add Expense")
                }
                
                Spacer()
                MidwayView(monthlyIncome: $monthlyIncome, expenses: $expenses, fixedCosts: fixedcost)
               
            }
        }
    }
    func createCurrencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}

struct Expense: Identifiable {
    var id = UUID()
    var amount: Double
    var label: String
}
struct MidwayView: View {
    @Binding var monthlyIncome: Double
    @Binding var expenses: [Expense]
    var fixedCosts: Double
    var remainingIncome: Double {
        calculateRemainingIncome_fixed()
    }
    
    var formattedRemainingIncome: String {
        String(format: "%.2f", remainingIncome)
    }
    
    var body: some View {
        Text("Remaining Income: \(formattedRemainingIncome)")
            .font(.headline)
            .padding()
        NavigationLink(destination: VariableExpenseView(remainingIncome: Double(remainingIncome), monthlyIncome: $monthlyIncome,fixedCosts: fixedCosts)) {
            RectangleButton(color: Color.red, title: "Done with Fixed")
        }
    }
    
    func calculateRemainingIncome_fixed() -> Double {
        let totalFixedExpenses = expenses.reduce(0) { $0 + $1.amount }
        return monthlyIncome - totalFixedExpenses
    }
    
}
struct VariableExpenseView: View {
    var remainingIncome: Double
    @Binding var monthlyIncome: Double
    @State private var v_expenses: [Expense] = []
    var fixedCosts: Double
    var variableCosts: Double {
            v_expenses.reduce(0) { $0 + $1.amount }
        }
    var body: some View {
        Text("Variable Expenses")
        
        ForEach(v_expenses.indices, id: \.self) { index in
            HStack {
                TextField("Enter expense", value: self.$v_expenses[index].amount, formatter: createCurrencyFormatter(), onCommit: {
                    // Parse the input and perform any necessary operations
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                TextField("Expense label", text: self.$v_expenses[index].label, onCommit: {
                    // Do nothing or perform any additional actions you need
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
        }
        
        Button(action: {
            self.v_expenses.append(Expense(amount: 0.0, label: ""))
        }) {
            Text("Add Expense")
        }
        Spacer()
        VariableRunningTotalView(remainingIncome: remainingIncome, monthlyIncome: $monthlyIncome, v_expenses: $v_expenses,variableCosts: variableCosts, fixedCosts: fixedCosts)
    }
    func createCurrencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
struct VariableRunningTotalView: View {
    var remainingIncome: Double
    @Binding var monthlyIncome: Double
    @Binding var v_expenses: [Expense]
    var variableCosts: Double
    var fixedCosts: Double
    var variableremainingIncome: Double {
        calculateRemainingIncome_variable()
    }
    
    var formattedRemainingIncome_var: String {
        String(format: "%.2f", variableremainingIncome)
    }
    
    var body: some View {
        Text("Remaining Income: \(formattedRemainingIncome_var)")
            .font(.headline)
            .padding()
        NavigationLink(destination: GraphView(monthlyIncome: $monthlyIncome, variableCosts: variableCosts, fixedCosts: fixedCosts, variableremainingIncome: variableremainingIncome)) {
            RectangleButton(color: Color.red, title: "Done with Variable")
        }
    }
    
    func calculateRemainingIncome_variable() -> Double {
        let totalVariableExpenses = v_expenses.reduce(0) { $0 + $1.amount }
        return remainingIncome - totalVariableExpenses
    }
    
}
struct GraphView: View{
    @Binding var monthlyIncome: Double
    var variableCosts: Double
    var fixedCosts: Double
    var variableremainingIncome: Double
    var body: some View {
        VStack {
            Text("Monthly Budget Breakdown")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.red)
                .padding()
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.green)
                    .frame(height: barHeight(value: variableremainingIncome))
                    .overlay(Text("\(Int(variableremainingIncome)) Dollars Remaining").foregroundColor(.white))
                Rectangle()
                    .fill(Color.orange)
                    .frame(height: barHeight(value: variableCosts))
                    .overlay(Text("\(Int(variableCosts)) Total Variable Cost").foregroundColor(.white))
                
                Rectangle()
                    .fill(Color.red)
                    .frame(height: barHeight(value: fixedCosts))
                    .overlay(Text("\(Int(fixedCosts)) Total Fixed Cost").foregroundColor(.white))
            }
            .frame(height: 200)
            
        }
        
    }
    
    private func barHeight(value: Double) -> CGFloat {
        let maximumHeight: CGFloat = 200
        let maximumValue = max(monthlyIncome, variableCosts, fixedCosts)
        return CGFloat(value / maximumValue) * maximumHeight
    }
}
