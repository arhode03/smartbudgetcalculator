//
//  CalculatorView.swift
//  BudgetApp
//
//  Created by Alex Rhodes and Nicholas Mollica on 11/9/23.
//

import Foundation
import SwiftUI

struct CalculatorView: View {
    @State private var monthlyIncome: Double = 0.0
    @State private var expenses: [Expense] = []
    var fixedcost: Double {
        expenses.reduce(0) { $0 + $1.amount }           
    }

    var body: some View {                    //The view that takes user input for monthly income and fixed expenses
        ScrollView {
            VStack {
                Text("Enter your monthly Income")
                    .font(.headline)
                    .padding()
                
                TextField("Enter monthly income", value: $monthlyIncome, formatter: createCurrencyFormatter(), onCommit: {
                    // Do nothing or perform any additional actions you need
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())        //font
                .padding()
                
                Text("Fixed Expenses")
                
                ForEach(expenses.indices, id: \.self) { index in         //loop for adding expenses
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
                
                Button(action: {                              //Button to add more fixed expenses 
                    self.expenses.append(Expense(amount: 0.0, label: ""))
                }) {
                    Text("Add Expense")
                }
                
                Spacer()
                MidwayView(monthlyIncome: $monthlyIncome, expenses: $expenses, fixedCosts: fixedcost)
               
            }
        }
    }
    func createCurrencyFormatter() -> NumberFormatter {           //function that adds currency formatting
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}

struct Expense: Identifiable {          //struct for 2d array of expenses
    var id = UUID()
    var amount: Double
    var label: String
}
struct MidwayView: View {
    @Binding var monthlyIncome: Double          //binding variables to pass data between views
    @Binding var expenses: [Expense]            //brings remaining income to next view
    var fixedCosts: Double
    var remainingIncome: Double {
        calculateRemainingIncome_fixed()
    }
    
    var formattedRemainingIncome: String {           //formats remaining income to 2 decimal places
        String(format: "%.2f", remainingIncome)
    }
    
    var body: some View {                                            //bottom half of calculator view
        Text("Remaining Income: \(formattedRemainingIncome)")
            .font(.headline)
            .padding()
        NavigationLink(destination: VariableExpenseView(remainingIncome: Double(remainingIncome), monthlyIncome: $monthlyIncome, expenses: $expenses, fixedCosts: fixedCosts)) {
            RectangleButton(color: Color.red, title: "Done with Fixed")            //adds button to move to next view
        }
    }
    
    func calculateRemainingIncome_fixed() -> Double {                            //calculates remaining income
        let totalFixedExpenses = expenses.reduce(0) { $0 + $1.amount }           //used above to pass to next view
        return monthlyIncome - totalFixedExpenses
    }
    
}
struct VariableExpenseView: View {                 //the next view that takes variable expenses
    var remainingIncome: Double
    @Binding var monthlyIncome: Double
    @State private var v_expenses: [Expense] = []
    @Binding var expenses: [Expense]
    var fixedCosts: Double
    var variableCosts: Double {
            v_expenses.reduce(0) { $0 + $1.amount }
        }
    var body: some View {            //takes $ value and label for variable expenses
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
            self.v_expenses.append(Expense(amount: 0.0, label: ""))    //same add expense button from above
        }) {
            Text("Add Expense")
        }
        Spacer()
        VariableRunningTotalView(remainingIncome: remainingIncome, monthlyIncome: $monthlyIncome, v_expenses: $v_expenses, expenses: $expenses,variableCosts: variableCosts, fixedCosts: fixedCosts)
    }
    func createCurrencyFormatter() -> NumberFormatter {     //function that adds currency formatting
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
struct VariableRunningTotalView: View {      //view that displays remaining income and button to move to next view
    var remainingIncome: Double
    @Binding var monthlyIncome: Double
    @Binding var v_expenses: [Expense]
    @Binding var expenses: [Expense]
    var variableCosts: Double
    var fixedCosts: Double
    var variableremainingIncome: Double {
        calculateRemainingIncome_variable()
    }
    
    var formattedRemainingIncome_var: String {      //formats remaining income to 2 decimal places
        String(format: "%.2f", variableremainingIncome)
    }
    
    var body: some View {        //displays remaining income and button to move to next view
        Text("Remaining Income: \(formattedRemainingIncome_var)")
            .font(.headline)
            .padding()
        NavigationLink(destination: GraphView(monthlyIncome: $monthlyIncome, variableCosts: variableCosts, fixedCosts: fixedCosts, variableremainingIncome: variableremainingIncome, v_expenses: $v_expenses, expenses: $expenses)) {
            RectangleButton(color: Color.red, title: "Done with Variable")
        }
    }
    
    func calculateRemainingIncome_variable() -> Double {             //calculates remaining income
        let totalVariableExpenses = v_expenses.reduce(0) { $0 + $1.amount }    //this function is called above in the view
        return remainingIncome - totalVariableExpenses
    }
    
}
struct GraphView: View{                   //view that displays the graph and buttons for detailed expenses or home
    @Binding var monthlyIncome: Double
    var variableCosts: Double
    var fixedCosts: Double
    var variableremainingIncome: Double
    private var taxAmount: Double {
        if monthlyIncome <= 25.67 {
                return 0
            } else if monthlyIncome <= 91.83 {
                return (monthlyIncome - 25.67) * 0.10
            } else if monthlyIncome <= 294.42 {
                return 6.62 + (monthlyIncome - 91.83) * 0.12
            } else if monthlyIncome <= 598.58 {
                return 30.93 + (monthlyIncome - 294.42) * 0.22
            } else if monthlyIncome <= 1119.42 {
                return 97.84 + (monthlyIncome - 598.58) * 0.24
            } else if monthlyIncome <= 1414.58 {
                return 222.84 + (monthlyIncome - 1119.42) * 0.32
            } else if monthlyIncome <= 3497.92 {
                return 317.30 + (monthlyIncome - 1414.58) * 0.35
            } else {
                return 1046.46 + (monthlyIncome - 3497.92) * 0.37
        }
               }
    @Binding var v_expenses: [Expense]
    @Binding var expenses: [Expense]
    var body: some View {
        VStack {
            Text("Monthly Budget Breakdown")
                .font(.system(size: 20, weight: .bold))     //title
                .foregroundColor(.red)
                .padding()
                Spacer()
            
            VStack(spacing: 0) {                    //graph start
                Rectangle()
                    .fill(Color.green)           //green section is remaining income
                    .frame(height: barHeight(value: variableremainingIncome))
                    .overlay(Text("\(Int(variableremainingIncome - taxAmount)) Dollars Remaining").foregroundColor(.white))
                    .overlay(Text(String(format: "%.2f%%", (variableremainingIncome - taxAmount) / monthlyIncome * 100))
                            .foregroundColor(.white)
                            .offset(x: 0, y: -15)
                            .font(.system(size: 15, weight: .bold))
                    )
                Rectangle()
                    .fill(Color.orange)             //orange section is the total variable costs
                    .frame(height: barHeight(value: variableCosts))
                    .overlay(Text("\(Int(variableCosts)) Total Variable Cost").foregroundColor(.white))
                    .overlay(Text(String(format: "%.2f%%", variableCosts / monthlyIncome * 100))
                            .foregroundColor(.white)
                            .offset(x: 0, y: -15)
                            .font(.system(size: 15, weight: .bold))
                    )
                
                Rectangle()
                    .fill(Color.red)                  //red section is the total fixed costs
                    .frame(height: barHeight(value: fixedCosts))
                    .overlay(Text("\(Int(fixedCosts)) Total Fixed Cost").foregroundColor(.white))
                    .overlay(Text(String(format: "%.2f%%", fixedCosts / monthlyIncome * 100))
                            .foregroundColor(.white)
                            .offset(x: 0, y: -15)
                            .font(.system(size: 15, weight: .bold))
                    )
                Rectangle()
                    .fill(Color.brown)                  //red section is the total fixed costs
                    .frame(height: barHeight(value: taxAmount))
                    .overlay(Text("\(Int(taxAmount)) Total Taxed Cost").foregroundColor(.white))
                    .overlay(Text(String(format: "%.2f%%", taxAmount / monthlyIncome * 100))
                            .foregroundColor(.white)
                            .offset(x: 0, y: -15)
                            .font(.system(size: 15, weight: .bold))
                    )
                
            }
            .frame(height: 200)
            .padding()
            Text("Total Tax amount: $ \(taxAmount, specifier: "%.2f")")
                .font(.headline)
                .padding()
            NavigationLink(destination: ExpensesListView(expenses: $expenses, v_expenses: $v_expenses)) {
                RectangleButton(color: Color.red, title: "Detailed Expenses")
            }
            NavigationLink(destination: {
                ContentView()
            }, label: {
                RectangleButton(color: Color.red, title: "Back to Home")
            })
           
        }
    }
    
    private func barHeight(value: Double) -> CGFloat {           //function that calculates the height of the bars based on $
        let maximumHeight: CGFloat = 200
        let maximumValue = max(monthlyIncome, variableCosts, fixedCosts)
        return CGFloat(value / maximumValue) * maximumHeight
    }
}
struct ExpensesListView: View {           //view that displays the detailed expenses
    @Binding var expenses: [Expense]
    @Binding var v_expenses: [Expense]
    
    var body: some View {
        List {
            Section(header: Text("Fixed Expenses")) {        //displays table of fixed expenses
                ForEach(expenses) { expense in
                    HStack {
                        Text("\(expense.label)")
                        Spacer()
                        Text(String(format: "%.2f", expense.amount)) // Update to display 2 digits after decimal
                    }
                }
            }
            
            Section(header: Text("Variable Expenses")) {        //displays table of variable expenses
                ForEach(v_expenses) { expense in
                    HStack {
                        Text("\(expense.label)")
                        Spacer()
                        Text(String(format: "%.2f", expense.amount)) // Update to display 2 digits after decimal
                    }
                }
            }
        }
    }
}

