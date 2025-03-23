//
//  Utilities.swift
//  Weathery
//
//  Created by Anna Filin on 17/03/2025.
//

import Foundation

func decodeJSON<T: Decodable>(from data: Data) -> T? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601

    do {
        return try decoder.decode(T.self, from: data)
    } catch DecodingError.keyNotFound(let key, let context) {
        print("❌ Error: Key '\(key.stringValue)' not found — \(context.debugDescription)")
    } catch DecodingError.typeMismatch(_, let context) {
        print("❌ Error: Type mismatch — \(context.debugDescription)")
    } catch DecodingError.valueNotFound(let type, let context) {
        print("❌ Error: Value of type \(type) not found — \(context.debugDescription)")
    } catch DecodingError.dataCorrupted(_) {
        print("❌ Error: JSON is corrupted")
    } catch {
        print("❌ Error: \(error.localizedDescription)")
    }
    return nil
}
