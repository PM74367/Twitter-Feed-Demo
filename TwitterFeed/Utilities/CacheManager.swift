//
//  CacheManager.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//

import Foundation

final class CacheManager {

    static let shared = CacheManager()

    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {}

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory,
                         in: .userDomainMask)[0]
    }

    // MARK: - Save

    @discardableResult
    func save<T: Encodable>(
        _ object: T,
        fileName: String
    ) -> Bool {

        let url = documentsDirectory.appendingPathComponent(fileName)

        do {
            let data = try encoder.encode(object)
            try data.write(to: url, options: .atomic)
            return true
        } catch {
            print("Cache save error:", error)
            return false
        }
    }

    // MARK: - Read

    func read<T: Decodable>(
        fileName: String,
        as type: T.Type
    ) -> T? {

        let url = documentsDirectory.appendingPathComponent(fileName)

        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(type, from: data)
        } catch {
            print("Cache read error:", error)
            return nil
        }
    }

    // MARK: - Delete

    func delete(fileName: String) {
        let url = documentsDirectory.appendingPathComponent(fileName)
        try? fileManager.removeItem(at: url)
    }
}
