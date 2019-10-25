import XCTest
@testable import CxValidate
import Combine
import Foundation
import CxTest
import CxDisposeBag

final class ValidateTests: XCTestCase {
  var bag: DisposeBag!
  
  let validResponse = HTTPURLResponse(url: URL(string: "https://something.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
  let non200response = HTTPURLResponse(url: URL(string: "https://something.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
  let notHttpUrlResponse = URLResponse(url: URL(string: "https://something.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
  
  override func setUp() {
    bag = DisposeBag()
  }
  
  override func tearDown() {
    bag = nil
  }
  
  func testNon200Response_ResultsInURLError() {
    Just((data: Data(), response: non200response))
      .validate()
      .assertError(equals: URLError(.badServerResponse))
      .disposed(by: bag)
  }
  
  func testNonHttpUrlResponse_ResultsInURLError() {
    Just((data: Data(), response: notHttpUrlResponse))
      .validate()
      .assertError(equals: URLError(.badServerResponse))
      .disposed(by: bag)
  }
  
  func testValidResponse_DoesNotError() {
    Just((data: Data(), response: validResponse))
      .validate()
      .assertNoFailure()
      .sink { _ in }
      .disposed(by: bag)
  }

}
