import XCTest
@testable import Tensai

final class TriviaQuizConfigTests: XCTestCase {
    
    func testBasicURL() {
        let config = TriviaQuizConfig()
        let expectedURL = URL(string: "https://opentdb.com/api.php?amount=10")
        XCTAssertEqual(config.apiURL, expectedURL)
    }
    
    func testURLWithCategoryParameterOnly() {
        var config = TriviaQuizConfig()
        config.categoryIndex = 1
        let expectedURL = URL(
            string: "https://opentdb.com/api.php?amount=10&category=9"
        )
        XCTAssertEqual(config.apiURL, expectedURL)
    }
    
    func testURLWithDifficultyParameterOnly() {
        var config = TriviaQuizConfig()
        config.difficultyIndex = 1
        let expectedURL = URL(
            string: "https://opentdb.com/api.php?amount=10&difficulty=easy"
        )
        XCTAssertEqual(config.apiURL, expectedURL)
    }
    
    func testURLWithTypeParameterOnly() {
        var config = TriviaQuizConfig()
        config.questionTypeIndex = 1
        let expectedURL = URL(
            string: "https://opentdb.com/api.php?amount=10&type=multiple"
        )
        XCTAssertEqual(config.apiURL, expectedURL)
    }
    
    func testURLWithCustomizedAmountParameterOnly() {
        var config = TriviaQuizConfig()
        config.questionCountIndex = 8
        let expectedURL = URL(string: "https://opentdb.com/api.php?amount=50")
        XCTAssertEqual(config.apiURL, expectedURL)
    }
    
    func testURLWithAllParameters() {
        var config = TriviaQuizConfig()
        config.categoryIndex = 1
        config.difficultyIndex = 1
        config.questionTypeIndex = 1
        config.questionCountIndex = 8
        let expectedURL = URL(
            string: [
                "https://opentdb.com/api.php?amount=50",
                "category=9",
                "difficulty=easy",
                "type=multiple"
            ].joined(separator: "&")
        )
        XCTAssertEqual(config.apiURL, expectedURL)
    }
    
    func testURLFromPropertyList() {
        let json = """
        {
            "categoryIndex": 11,
            "difficultyIndex": 3,
            "questionTypeIndex": 2,
            "questionCountIndex": 0
        }
        """.data(using: .utf8)
        let config = TriviaQuizConfig(propertyList: json)
        let expectedURL = URL(
            string: [
                "https://opentdb.com/api.php?amount=10",
                "category=19",
                "difficulty=hard",
                "type=boolean"
            ].joined(separator: "&")
        )
        XCTAssertEqual(config?.apiURL, expectedURL)
    }
}
