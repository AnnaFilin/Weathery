//
//  File.swift
//  Weathery
//
//  Created by Anna Filin on 04/02/2025.
//
import Foundation

extension Bundle {

    func decode<T: Codable>(_ file: String) -> T? {
            guard let url = self.url(forResource: file, withExtension: nil),
                  let data = try? Data(contentsOf: url) else {
                print("❌ Ошибка: Не удалось загрузить файл \(file)")
                return nil
            }
            
            return decodeJSON(from: data)
        }
}
