//
//  String+Extension.swift
//  BudgetApp
//
//  Created by Vitalii Navrotskyi on 24.04.2024.
//

import Foundation

extension String {

    var isNumeric: Bool {
        Double(self) != nil
    }

    func isGreatorThan(_ value: Double) -> Bool {
        guard self.isNumeric else {
            return false
        }

        return Double(self)! > value
    }
}
