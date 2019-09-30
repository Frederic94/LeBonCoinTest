//
//  Storage.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 30/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

typealias Handler<T> = (T) -> Void

protocol ReadableStorage {
    func fetchValue(for key: String) throws -> Data
    func fetchValue(for key: String, handler: @escaping Handler<Data>)
}

protocol WritableStorage {
    func save(value: Data, for key: String) throws
    func save(value: Data, for key: String, handler: @escaping Handler<Data>)
}

typealias Storage = ReadableStorage & WritableStorage

enum StorageError: Error {
    case notFound
    case cantWrite(Error)
}

public final class DiskStorage {
    private let queue: DispatchQueue
    private let fileManager: FileManager
    private let path: URL
    
    init(path: URL, queue: DispatchQueue = .init(label: "DiskCache.Queue"), fileManager: FileManager = FileManager.default) {
        self.path = path
        self.queue = queue
        self.fileManager = fileManager
    }
}

extension DiskStorage: WritableStorage {
    func save(value: Data, for key: String) throws {
        let url = path.appendingPathComponent(key)
        do {
            try self.createFolders(in: url)
            try value.write(to: url, options: .atomic)
        } catch {
            throw StorageError.cantWrite(error)
        }
    }
    
    func save(value: Data, for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            do {
                try self.save(value: value, for: key)
                handler(value)
            } catch {
                //handler(.failure(error))
            }
        }
    }
}

extension DiskStorage: ReadableStorage {
    func fetchValue(for key: String) throws -> Data {
        let url = path.appendingPathComponent(key)
        guard let data = fileManager.contents(atPath: url.path) else {
            throw StorageError.notFound
        }
        return data
    }
    
    func fetchValue(for key: String, handler: @escaping Handler<Data>) {
        queue.async {
            do {
                let value = try self.fetchValue(for: key)
                handler(value)
            } catch {
                //handler(.failure(error))
            }
        }
    }
}

private extension DiskStorage {
    private func createFolders(in url: URL) throws {
        let folderUrl = url.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: folderUrl.path) {
            try fileManager.createDirectory(
                at: folderUrl,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
}
