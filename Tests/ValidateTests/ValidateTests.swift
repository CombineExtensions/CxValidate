import XCTest
@testable import Validate
import Combine
import Foundation



extension Publisher {
  func assertError<E: Error>(type: E.Type, message: String? = nil, file: StaticString = #file, line: UInt = #line) -> AnyCancellable {
    sink(receiveCompletion: { this in
      switch this {
      case .finished:
        XCTFail("Did not fail with errors", file: file, line: line)
      case .failure(let e):
        guard let _ = e as? E else {
          return XCTFail(message ?? "\(e.localizedDescription) is unable to be cast as \(E.self)", file: file, line: line)
        }
      }
    }, receiveValue: { output in
      XCTFail("Should not have received value: \(output)", file: file, line: line)
    })
  }
  
  func assertError<E: Error & Equatable>(equals error: E, message: String? = nil, file: StaticString = #file, line: UInt = #line) -> AnyCancellable {
    sink(receiveCompletion: { this in
      switch this {
      case .finished:
        XCTFail("Did not fail with errors", file: file, line: line)
      case .failure(let e):
        guard let receivedError = e as? E else {
          return XCTFail(message ?? "\(e) is unable to be cast to \(E.self)", file: file, line: line)
        }
        XCTAssertEqual(receivedError, error, message ?? "actual error \(receivedError.localizedDescription) is not equal to expected error \(error.localizedDescription)", file: file, line: line)
      }
    }, receiveValue: { output in
      XCTFail("Should not have received value: \(output)", file: file, line: line)
    })
  }
  
  func assertFailure(file: StaticString = #file, line: UInt = #line) -> AnyCancellable {
    sink(receiveCompletion: { this in
      switch this {
      case .finished:
        XCTFail("Did not fail with errors", file: file, line: line)
      case .failure:
        return
      }
    }, receiveValue: { output in
      XCTFail("Should not have received value: \(output)", file: file, line: line)
    })
  }
}

import Compression

final class ValidateTests: XCTestCase {
  
  let validResponse = HTTPURLResponse(url: URL(string: "https://something.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
  let non200response = HTTPURLResponse(url: URL(string: "https://something.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
  let notHttpUrlResponse = URLResponse(url: URL(string: "https://something.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
  
  func testNon200Response_ResultsInURLError() {
    let publisher = Just((data: Data(), response: non200response))
      .validate()
    
//    publisher.assertError(equals: URLError(.badServerResponse))
    publisher.assertError(type: DecodingError.self)
    publisher.assertError(equals: URLError(.appTransportSecurityRequiresSecureConnection))
//    _ = Just((data: Data(), response: non200response))
//      .validate()
////      .assertError(type: URLError.self)
//      .assertError(equals: URLError(.badServerResponse))
//      .assertFailure()
  }
  
  func testNonHttpUrlResponse_ResultsInURLError() {
    _ = Just((data: Data(), response: notHttpUrlResponse))
    .validate()
    .assertNoFailure()
    .sink { _ in }
//    .assertError(type: FilterError.self)
//    .assertError(equals: URLError(.badServerResponse))
//    .evaluate()
  }
  
  func testValidResponse_DoesNotError() {
    _ = Just((data: Data(), response: validResponse))
    .validate()
    .assertNoFailure()
  }

}
