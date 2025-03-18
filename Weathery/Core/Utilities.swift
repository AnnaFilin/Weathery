//
//  Utilities.swift
//  Weathery
//
//  Created by Anna Filin on 17/03/2025.
//

import Foundation

/// Универсальная функция декодирования JSON
func decodeJSON<T: Decodable>(from data: Data) -> T? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601

    do {
        return try decoder.decode(T.self, from: data)
    } catch DecodingError.keyNotFound(let key, let context) {
        print("❌ Ошибка: Ключ '\(key.stringValue)' не найден — \(context.debugDescription)")
    } catch DecodingError.typeMismatch(_, let context) {
        print("❌ Ошибка: Несоответствие типов — \(context.debugDescription)")
    } catch DecodingError.valueNotFound(let type, let context) {
        print("❌ Ошибка: Значение \(type) отсутствует — \(context.debugDescription)")
    } catch DecodingError.dataCorrupted(_) {
        print("❌ Ошибка: JSON повреждён")
    } catch {
        print("❌ Ошибка: \(error.localizedDescription)")
    }
    return nil
}
