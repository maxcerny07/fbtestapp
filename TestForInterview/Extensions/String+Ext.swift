//
//  String+Ext.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import Foundation

extension String {
    func toYear(format: String = "yyyy-MM-dd") -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = formatter.date(from: self) else { return nil }
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        return yearFormatter.string(from: date)
    }
}
