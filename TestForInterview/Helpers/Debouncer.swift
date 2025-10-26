//
//  Debouncer.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import Foundation

final class Debouncer {
    private var timer: Timer?
    private let interval: TimeInterval
    
    init(interval: TimeInterval) {
        self.interval = interval
    }
    
    func call(_ block: @escaping ()->Void) {
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: self.interval, repeats: false) { _ in block() }
        }
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}
