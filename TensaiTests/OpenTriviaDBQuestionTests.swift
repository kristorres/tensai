import XCTest
@testable import Tensai

final class OpenTriviaDBQuestionTests: XCTestCase {
    
    func testInitWithProperties() {
        let question = OpenTriviaDB.Question(
            "The 1995 film <i>Clueless</i> is based on what Jane Austen novel?",
            category: "Movies",
            difficulty: .hard,
            type: .multipleChoice,
            correctAnswer: "<i>Emma</i>",
            incorrectAnswers: [
                "<i>Sense and Sensibility</i>",
                "<i>Pride and Prejudice</i>",
                "<i>Mansfield Park</i>"
            ]
        )
        
        testQuestion(question)
    }
    
    func testInitWithDecoder() throws {
        let json = """
        {
            "category": "Movies",
            "type": "multiple",
            "difficulty": "hard",
            "question": "The 1995 film <i>Clueless</i> is based on what Jane Austen novel?",
            "correct_answer": "<i>Emma</i>",
            "incorrect_answers": [
                "<i>Sense and Sensibility</i>",
                "<i>Pride and Prejudice</i>",
                "<i>Mansfield Park</i>"
            ]
        }
        """.data(using: .utf8)!
        
        let question = try JSONDecoder()
            .decode(OpenTriviaDB.Question.self, from: json)
        
        testQuestion(question)
    }
    
    private func testQuestion(_ question: OpenTriviaDB.Question) {
        XCTAssertEqual(
            question.string,
            "The 1995 film Clueless is based on what Jane Austen novel?"
        )
        XCTAssertEqual(question.category, "Movies")
        XCTAssertEqual(question.difficulty, .hard)
        XCTAssertEqual(question.type, .multipleChoice)
        XCTAssertEqual(question.correctAnswer, "Emma")
        XCTAssertEqual(
            question.incorrectAnswers,
            ["Sense and Sensibility", "Pride and Prejudice", "Mansfield Park"]
        )
    }
}
