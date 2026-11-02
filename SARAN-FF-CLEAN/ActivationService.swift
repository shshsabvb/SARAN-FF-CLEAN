import Foundation
import UIKit

enum ActivationService {
    static func activate(key: String) async throws -> Bool {
        guard let device = UIDevice.current.identifierForVendor?.uuidString else {
            throw NSError(domain: "SARAN FF", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not create device identifier."])
        }
        let url = URL(string: "https://saran-ff-api.onrender.com/activate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "key": key.trimmingCharacters(in: .whitespacesAndNewlines), "device": device
        ])
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard (200...299).contains(http.statusCode) else {
            throw NSError(domain: "SARAN FF", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: String(data: data, encoding: .utf8) ?? "Activation rejected"])
        }
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { throw URLError(.cannotParseResponse) }
        for name in ["success", "valid", "activated"] {
            if let value = json[name] as? Bool { return value }
        }
        throw NSError(domain: "SARAN FF", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unexpected activation API response. Please verify the server response format."])
    }
}
