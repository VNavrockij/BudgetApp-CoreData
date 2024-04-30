//
//  Double+Extension.swift
//  BudgetApp
//
//  Created by Vitalii Navrotskyi on 30.04.2024.
//

import Foundation

extension Double {

    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
