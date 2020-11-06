import XCTest
@testable import Tensai

final class TriviaQuizCreatorFormTests: XCTestCase {
    
    func testBasicURL() {
        let form = TriviaQuizCreatorForm()
        let expectedURL = URL(string: "https://opentdb.com/api.php?amount=10")
        XCTAssertEqual(form.apiURL, expectedURL)
    }
    
    func testURLWithCategoryParameterOnly() {
        let form = TriviaQuizCreatorForm()
        form.categoryIndex = 1
        let expectedURL = URL(
            string: "https://opentdb.com/api.php?amount=10&category=9"
        )
        XCTAssertEqual(form.apiURL, expectedURL)
    }
    
    func testURLWithDifficultyParameterOnly() {
        let form = TriviaQuizCreatorForm()
        form.difficultyIndex = 1
        let expectedURL = URL(
            string: "https://opentdb.com/api.php?amount=10&difficulty=easy"
        )
        XCTAssertEqual(form.apiURL, expectedURL)
    }
    
    func testURLWithTypeParameterOnly() {
        let form = TriviaQuizCreatorForm()
        form.questionTypeIndex = 1
        let expectedURL = URL(
            string: "https://opentdb.com/api.php?amount=10&type=multiple"
        )
        XCTAssertEqual(form.apiURL, expectedURL)
    }
    
    func testURLWithCustomizedAmountParameterOnly() {
        let form = TriviaQuizCreatorForm()
        form.questionCountIndex = 8
        let expectedURL = URL(string: "https://opentdb.com/api.php?amount=50")
        XCTAssertEqual(form.apiURL, expectedURL)
    }
    
    func testURLWithAllParameters() {
        let form = TriviaQuizCreatorForm()
        form.categoryIndex = 1
        form.difficultyIndex = 1
        form.questionTypeIndex = 1
        form.questionCountIndex = 8
        let expectedURL = URL(
            string: [
                "https://opentdb.com/api.php?amount=50",
                "category=9",
                "difficulty=easy",
                "type=multiple"
            ].joined(separator: "&")
        )
        XCTAssertEqual(form.apiURL, expectedURL)
    }
}
