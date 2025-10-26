//
//  UserConfigProvider.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import UIKit

class UserConfigProvider {
    static let shared = UserConfigProvider()
    
    private let themeKey = "app_theme"
    
    private init() {}
    
    var currentTheme: UIUserInterfaceStyle {
        get {
            let themeValue = UserDefaults.standard.integer(forKey: themeKey)
            return UIUserInterfaceStyle(rawValue: themeValue) ?? .unspecified
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            applyTheme(theme: newValue)
        }
    }
    
    func applyTheme(theme: UIUserInterfaceStyle) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = theme
        }
    }
    
    func setupInitialTheme() {
        applyTheme(theme: currentTheme)
    }
}
