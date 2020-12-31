import XCTest
@testable import Tensai

final class TriviaQuizRequestTests: XCTestCase {
    
    private let request = TriviaQuizRequest()
    
    func testMakingURLRequest() {
        var config = TriviaQuizConfig()
        config.categoryIndex = 1
        config.difficultyIndex = 1
        config.questionTypeIndex = 1
        config.questionCountIndex = 8
        let urlRequest = request.makeRequest(from: config)
        let expectedURL = URL(
            string: [
                "https://opentdb.com/api.php?amount=50",
                "category=9",
                "difficulty=easy",
                "type=multiple"
            ].joined(separator: "&")
        )
        XCTAssertEqual(urlRequest.url, expectedURL)
    }
    
    func testParsingResponse() throws {
        let bundle = Bundle(for: type(of: self))
        let jsonURL = bundle.url(
            forResource: "john_carpenter_millionaire",
            withExtension: "json"
        )!
        let jsonData = try Data(contentsOf: jsonURL)
        let response = try request.parseResponse(data: jsonData)
        XCTAssertEqual(response.code, 0)
        XCTAssertEqual(response.questions.count, 15)
    }
}
