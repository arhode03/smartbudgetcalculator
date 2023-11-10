//
//  MidwayView.swift
//  BudgetApp
//
//  Created by Alex Rhodes on 11/9/23.
//

import Foundation
import SwiftUI

struct MidwayView: View {
    @Binding var monthlyIncome: Double
    @Binding var f_expenses: [Expense]
    @Binding var v_expenses: [Expense]
    
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
    }
    
    func calculateRemainingIncome_fixed() -> Double {
        let totalFixedExpenses = f_expenses.reduce(0) { $0 + $1.amount }
        return monthlyIncome - totalFixedExpenses
    }
}


