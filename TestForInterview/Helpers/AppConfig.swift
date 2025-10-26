//
//  AppConfig.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import Foundation

enum AppConfig {
    static var apiVersion: String {
        Bundle.main.infoDictionary?["API_VERSION"] as? String ?? ""
    }
    
    static var bearerToken: String {
        Bundle.main.infoDictionary?["API_BEARER_TOKEN"] as? String ?? ""
    }
}
