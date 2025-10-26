//
//  AppLoger.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import Foundation

public final class AppLoger {

    public static let shared = AppLoger()
    private init() {}
    
    // MARK: - Types
    public enum LogType: String {
        case debug
        case network
        case persistence
        case error
        
        var emoji: String {
            switch self {
            case .debug: return "💬"
            case .network: return "🌐"
            case .persistence: return "💾"
            case .error: return "❌"
            }
        }
    }
    
    // MARK: - Properties
    private static let chunkBytes = 10_240
    
    // MARK: - Public API
    
    public func log(
        _ message: String?,
        type: LogType = .debug,
        title: String = #function,
        shouldPrint: Bool = true
    ) {
        guard shouldPrint else { return }
        
        let prefix = "\(type.emoji) [\(type.rawValue.uppercased())]"
        let time = AppLoger.timeString
        let formatted: String
        
        if let message = message {
            formatted = "\(time) \(prefix) \(title): \(message)"
        } else {
            formatted = "\(time) \(prefix) \(title)"
        }
        
        AppLoger.printInChunks(formatted)
    }
    
    public static func log(
        _ message: String?,
        type: LogType = .debug,
        title: String = #function,
        shouldPrint: Bool = true
    ) {
        AppLoger.shared.log(message, type: type, title: title, shouldPrint: shouldPrint)
    }
}

private extension AppLoger {
    static var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter.string(from: Date())
    }
    
    static func printInChunks(_ message: String) {
        let bytes = message.utf8
        var start = bytes.startIndex
        
        while start < bytes.endIndex {
            let end = bytes.index(start, offsetBy: chunkBytes, limitedBy: bytes.endIndex) ?? bytes.endIndex
            let slice = bytes[start..<end]
            print(String(decoding: slice, as: UTF8.self))
            start = end
        }
    }
}


