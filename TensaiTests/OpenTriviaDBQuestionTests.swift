import XCTest
@testable import Tensai

final class OpenTriviaDBQuestionTests: XCTestCase {
    
    func testInitWithProperties() {
        let question = OpenTriviaDB.Question(
            "Which is the only film in the <i>Fast & Furious</i> franchise that Vin Diesel did not appear in?",
            category: "Movies",
            difficulty: .hard,
            type: .multipleChoice,
            correctAnswer: "<i>2 Fast 2 Furious</i>",
            incorrectAnswers: [
                "<i>The Fast & The Furious: Tokyo Drift</i>",
                "<i>Fast Five</i>",
                "<i>Furious 7</i>"
            ]
        )
        
        XCTAssertEqual(
            question.string,
            "Which is the only film in the Fast & Furious franchise that Vin Diesel did not appear in?"
        )
        XCTAssertEqual(question.category, "Movies")
        XCTAssertEqual(question.difficulty, .hard)
        XCTAssertEqual(question.type, .multipleChoice)
        XCTAssertEqual(question.correctAnswer, "2 Fast 2 Furious")
        XCTAssertEqual(
            question.incorrectAnswers,
            ["The Fast & The Furious: Tokyo Drift", "Fast Five", "Furious 7"]
        )
    }
    
    func testInitWithDecoder() throws {
        let json = """
        {
            "category": "Movies",
            "type": "multiple",
            "difficulty": "hard",
            "question": "Which is the only film in the <i>Fast & Furious</i> franchise that Vin Diesel did not appear in?",
            "correct_answer": "<i>2 Fast 2 Furious</i>",
            "incorrect_answers": [
                "<i>The Fast & The Furious: Tokyo Drift</i>",
                "<i>Fast Five</i>",
                "<i>Furious 7</i>"
            ]
        }
        """.data(using: .utf8)!
        
        let question = try JSONDecoder()
            .decode(OpenTriviaDB.Question.self, from: json)
        
        XCTAssertEqual(
            question.string,
            "Which is the only film in the Fast & Furious franchise that Vin Diesel did not appear in?"
        )
        XCTAssertEqual(question.category, "Movies")
        XCTAssertEqual(question.difficulty, .hard)
        XCTAssertEqual(question.type, .multipleChoice)
        XCTAssertEqual(question.correctAnswer, "2 Fast 2 Furious")
        XCTAssertEqual(
            question.incorrectAnswers,
            ["The Fast & The Furious: Tokyo Drift", "Fast Five", "Furious 7"]
        )
    }
}
