import Combine
import Foundation

extension Publisher where Output == (data: Data, response: URLResponse) {
  /// Validates a successful `(200...299)` response status code from an HTTP response and forwards the response `Data`.
  /// On failure, it sends a `URLError` with  code `.badServerResponse`
  public func validate() -> Publishers.TryMap<Self, Data> {
    tryMap { data, response in
      guard
        let response = response as? HTTPURLResponse,
        200...299 ~= response.statusCode
      else { throw URLError(.badServerResponse) }
      
      return data
    }
  }
}
