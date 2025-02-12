//
//  File.swift
//  Weathery
//
//  Created by Anna Filin on 04/02/2025.
//
import Foundation
////
extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("JSON из файла:\n\(jsonString)")
//        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON.")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}

//extension Bundle {
//    func decode<T: Codable>(_ file: String) -> T {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            fatalError("❌ Failed to locate \(file) in bundle.")
//        }
//
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("❌ Failed to load \(file) from bundle.")
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601 // Поддержка формата ISO 8601 для дат
//
//        // Для отладки — вывод JSON, который загружается из файла
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("📄 JSON из файла:\n\(jsonString)")
//        }
//
//        do {
//            // Попытка декодирования
//            return try decoder.decode(T.self, from: data)
//        } catch DecodingError.keyNotFound(let key, let context) {
//            print("🔑 Ошибка: отсутствует ключ '\(key.stringValue)' — \(context.debugDescription)")
//            fatalError("❌ Failed to decode \(file) due to missing key '\(key.stringValue)'.")
//        } catch DecodingError.typeMismatch(let type, let context) {
//            print("🔄 Ошибка: несоответствие типа для \(type) — \(context.debugDescription)")
//            fatalError("❌ Failed to decode \(file) due to type mismatch for \(type).")
//        } catch DecodingError.valueNotFound(let type, let context) {
//            print("⚠️ Ошибка: отсутствует значение типа \(type) — \(context.debugDescription)")
//            fatalError("❌ Failed to decode \(file) due to missing \(type) value.")
//        } catch DecodingError.dataCorrupted(let context) {
//            print("🛠️ Ошибка: данные повреждены — \(context.debugDescription)")
//            fatalError("❌ Failed to decode \(file) due to corrupted data.")
//        } catch {
//            print("❗️ Ошибка: \(error.localizedDescription)")
//            fatalError("❌ Failed to decode \(file): \(error.localizedDescription)")
//        }
//    }
//}


//import Foundation
//
//extension Bundle {
//    func decode<T: Codable>(_ file: String) -> T? {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            print("❌ Ошибка: Не удалось найти \(file) в бандле.")
//            return nil
//        }
//
//        guard let data = try? Data(contentsOf: url) else {
//            print("❌ Ошибка: Не удалось загрузить \(file) из бандла.")
//            return nil
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601 // Поддержка ISO 8601 для дат
//
//        // Для отладки: вывод содержимого JSON
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("📄 JSON из файла:\n\(jsonString)")
//        }
//
//        do {
//            // Попытка декодирования
//            return try decoder.decode(T.self, from: data)
//        } catch DecodingError.keyNotFound(let key, let context) {
//            print("🔑 Ошибка: отсутствует ключ '\(key.stringValue)' — \(context.debugDescription)")
//        } catch DecodingError.typeMismatch(let type, let context) {
//            print("🔄 Ошибка: несоответствие типа \(type) — \(context.debugDescription)")
//        } catch DecodingError.valueNotFound(let type, let context) {
//            print("⚠️ Ошибка: отсутствует значение типа \(type) — \(context.debugDescription)")
//        } catch DecodingError.dataCorrupted(let context) {
//            print("🛠️ Ошибка: данные повреждены — \(context.debugDescription)")
//        } catch {
//            print("❗️ Общая ошибка: \(error.localizedDescription)")
//        }
//
//        // Возврат nil вместо краха
//        return nil
//    }
//}

//
//extension Bundle {
//    func decode<T: Codable>(_ file: String) -> T {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            print("❌ Ошибка: Не найден файл \(file) в Bundle.")
////            return nil
//            fatalError("Failed to locate \(file) in bundle.")
//        }
//
//        guard let data = try? Data(contentsOf: url) else {
//            print("❌ Ошибка: Не удалось загрузить данные из \(file).")
////            return nil
//            fatalError("Failed to locate \(file) in bundle.")
//        }
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//
//        // 🔹 Отладка: Вывод JSON перед декодированием
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("📄 JSON из файла:\n\(jsonString)")
//        }
//
//        do {
//            let decodedData = try decoder.decode(T.self, from: data)
//            return decodedData
//        } catch DecodingError.keyNotFound(let key, let context) {
//            print("🔑 Ошибка: отсутствует ключ '\(key.stringValue)' — \(context.debugDescription)")
//        } catch DecodingError.typeMismatch(let type, let context) {
//            print("🔄 Ошибка: несоответствие типа для \(type) — \(context.debugDescription)")
//        } catch DecodingError.valueNotFound(let type, let context) {
//            print("⚠️ Ошибка: отсутствует значение типа \(type) — \(context.debugDescription)")
//        } catch DecodingError.dataCorrupted(let context) {
//            print("🛠️ Ошибка: данные повреждены — \(context.debugDescription)")
//        } catch {
//            print("❗️ Ошибка: \(error.localizedDescription)")
//        }
//
////        return nil
//    }
//}
