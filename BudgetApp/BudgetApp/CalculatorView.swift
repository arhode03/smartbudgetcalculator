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

    var body: some View {
        ScrollView {
            VStack {
                Text("Enter your monthly budget")
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
                NavigationLink(destination: VariableView()) {
                    RectangleButton(color: Color.red, title: "Done with Fixed")
                }
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
