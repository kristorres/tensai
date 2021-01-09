import XCTest
@testable import Tensai

final class APILoaderTests: XCTestCase {
    
    private var loader: APIRequestLoader<TriviaQuizRequest>!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.noCaching
        configuration.protocolClasses = [MockURLProtocol.self]
        loader = APIRequestLoader<TriviaQuizRequest>(
            apiRequest: TriviaQuizRequest(),
            urlSession: URLSession(configuration: configuration)
        )
    }
    
    func testLoaderSuccess() throws {
        
        var config = TriviaQuizConfig()
        config.questionTypeIndex = 1
        config.questionCountIndex = 1
        
        let bundle = Bundle(for: type(of: self))
        let mockJSONURL = bundle.url(
            forResource: "john_carpenter_millionaire",
            withExtension: "json"
        )!
        let mockJSONData = try Data(contentsOf: mockJSONURL)
        
        MockURLProtocol.requestHandler = { request in
            let expectedURL = URL(
                string: "https://opentdb.com/api.php?amount=15&type=multiple"
            )
            XCTAssertEqual(request.url, expectedURL)
            return (HTTPURLResponse(), mockJSONData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        loader.loadAPIRequest(requestData: config) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.code, 0)
                XCTAssertEqual(response.questions.count, 15)
                expectation.fulfill()
            case .failure:
                XCTFail("Expectation failed.")
            }
        }
        wait(for: [expectation], timeout: 1)
    }
}

fileprivate class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(
        for request: URLRequest
    ) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received an unexpected request with no handler set.")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
