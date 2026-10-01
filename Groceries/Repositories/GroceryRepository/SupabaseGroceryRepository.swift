//
//  SupabaseGroceryRepository.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation

/// Fetches products from Supabase's REST API using plain `URLSession`.
/// The project URL and anon key are under Project Settings → API in the
/// Supabase dashboard. The anon key is public; Row Level Security limits it.
struct SupabaseGroceryRepository: GroceryRepository {
    let projectURL: URL
    let anonKey: String

    func fetchProducts() async throws -> [Product] {
        var components = URLComponents(url: projectURL.appending(path: "rest/v1/products"), resolvingAgainstBaseURL: false)!
        // Embed each product's promotions and price history via their foreign keys.
        components.queryItems = [URLQueryItem(name: "select", value: "*,promotions(*),price_history(*)")]

        var request = URLRequest(url: components.url!)
        request.setValue(anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try Self.decoder.decode([Product].self, from: data)
    }
}

// MARK: - Decoding

private extension SupabaseGroceryRepository {
    /// Postgres timestamps are ISO 8601, with or without fractional seconds.
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let string = try decoder.singleValueContainer().decode(String.self)
            let formatter = ISO8601DateFormatter()
            for options: ISO8601DateFormatter.Options in [[.withInternetDateTime, .withFractionalSeconds], [.withInternetDateTime]] {
                formatter.formatOptions = options
                if let date = formatter.date(from: string) { return date }
            }
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid date: \(string)"))
        }
        return decoder
    }()
}
