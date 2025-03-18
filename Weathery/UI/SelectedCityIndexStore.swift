//
//  SelectedCityIndexStore.swift
//  Weathery
//
//  Created by Anna Filin on 13/03/2025.
//

import SwiftUI
import Combine

class SelectedCityIndexStore: ObservableObject {
    @Published var selectedCityIndex: Int = 0 {
        didSet {
            print("⚠️ [SelectedCityIndexStore] selectedCityIndex изменён! Новое значение: \(selectedCityIndex)")
            
            // Добавляем источник изменения:
            Thread.callStackSymbols.forEach { print($0) }
        }
    }
}
