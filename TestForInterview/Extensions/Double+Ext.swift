//
//  Double+Ext.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import UIKit

extension Optional where Wrapped == Double {
    var asFormattedString: String {
        guard let value = self else { return "0" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
}
