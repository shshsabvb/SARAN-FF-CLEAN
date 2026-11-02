import Foundation
import UIKit

struct ActivationResponse: Decodable {
    let valid: Bool
    let message: String
    let expires: String?
}

final class ActivationService {
    static let shared = ActivationService()

    private let endpoint = URL(
        string: "https://saran-ff-api.onrender.com/activate"
    )!

    func activate(key: String) async throws -> ActivationResponse {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        let device = UIDevice.current.identifierForVendor?.uuidString ?? "UNKNOWN"

        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "key": key,
            "device": device
        ])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(ActivationResponse.self, from: data)

        guard http.statusCode == 200, result.valid else {
            throw NSError(
                domain: "Activation",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: result.message]
            )
        }

        return result
    }
}
