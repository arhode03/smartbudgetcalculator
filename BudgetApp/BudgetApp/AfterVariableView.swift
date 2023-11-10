//
//  AfterVariableView.swift
//  BudgetApp
//
//  Created by Alex Rhodes on 11/10/23.
//

import Foundation
import SwiftUI
struct AfterVariableView: View {
    @Binding var monthlyIncome: Double
    @Binding var f_expenses: [Expense]
    @Binding var v_expenses: [Expense]
    var var_remainingincome: Double {
        calculateRemainingIncome_variable()
    }
    var var_formattedRemainingIncome: String {
        String(format: "%.2f", var_remainingincome)
    }
    var body: some View {
        Text("Remaining Income: \(var_formattedRemainingIncome)")
            .font(.headline)
            .padding()
    }
    
    func calculateRemainingIncome_variable() -> Double {
        let totalVExpenses = v_expenses.reduce(0) { $0 + $1.amount }
        return var_remainingincome - totalVExpenses
    }
    }

