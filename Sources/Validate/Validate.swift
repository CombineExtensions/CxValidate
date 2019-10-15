import Combine
import Foundation

extension Publisher where Output == (data: Data, response: URLResponse) {
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
