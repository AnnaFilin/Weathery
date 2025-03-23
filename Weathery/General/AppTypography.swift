//
//  AppTypography.swift
//  Weathery
//
//  Created by Anna Filin on 16/02/2025.
//

import Foundation

import SwiftUI

struct AppTypography {
    static let title = Font.system(size: 18, weight: .bold, design: .default)
    static let largeTemperature = Font.system(size: 34, weight: .bold, design: .rounded)
    static let mediumTemperature = Font.system(size: 28, weight: .semibold, design: .rounded)
    static let subtitle = Font.system(size: 16, weight: .medium, design: .default)
    static let description = Font.system(size: 14, weight: .regular, design: .default)
    static let timeLabel = Font.system(size: 12, weight: .regular, design: .monospaced)
    
    static let factTitle = Font.system(size: 16, weight: .bold, design: .default)
    static let factData = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let factUnits = Font.system(size: 14, weight: .regular, design: .default)
    static let factLabel = Font.system(size: 12, weight: .medium, design: .monospaced)
    
    static let todayTemp = Font.system(size: 16, weight: .semibold, design: .rounded)
    static let todayDescription = Font.system(size: 16, weight: .medium, design: .default)
    
    static let weeklyTemp = Font.system(size: 12, weight: .semibold, design: .rounded)
    static let weeklyDescription = Font.system(size: 14, weight: .medium, design: .default)
    
    static let hourlyTemp = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let hourlyTime = Font.system(size: 14, weight: .medium, design: .monospaced)
}
