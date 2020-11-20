import XCTest
@testable import Tensai

final class TriviaQuizRequestTests: XCTestCase {
    
    private let request = TriviaQuizRequest()
    
    func testMakingURLRequest() {
        let form = TriviaQuizCreatorForm()
        form.categoryIndex = 1
        form.difficultyIndex = 1
        form.questionTypeIndex = 1
        form.questionCountIndex = 8
        let urlRequest = request.makeRequest(from: form)
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
