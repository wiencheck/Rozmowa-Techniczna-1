//
//  Database.swift
//  Rozmowa Techniczna 1
//
//  Created by Adam Wienconek on 29/09/2026.
//

import Foundation

final class Database {
    
    struct FileNotFoundError: Error {}
    
    func fetchItems(completion: @escaping (Result<[Item], any Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "images", ofType: "txt"),
            let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return completion(
                .failure(FileNotFoundError())
            )
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let items: [Item] = content.components(separatedBy: "\n")
                .enumerated()
                .compactMap { (idx, string) in
                    guard let imageURL = URL(string: string) else {
                        return nil
                    }
                    return Item(
                        id: idx,
                        title: "Item \(idx + 1)",
                        imageURL: imageURL
                    )
                }
            completion(.success(items))
        }
    }
}
