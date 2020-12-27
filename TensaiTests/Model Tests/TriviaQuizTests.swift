import XCTest
@testable import Tensai

final class TriviaQuizTests: XCTestCase {
    
    func testTriviaQuiz() {
        
        var triviaQuiz = TriviaQuiz(
            questions: [
                OTDQuestion(
                    category: "Geography",
                    type: .multipleChoice,
                    difficulty: .hard,
                    text: "What is Canada’s largest island?",
                    correctAnswer: "Baffin Island",
                    incorrectAnswers: [
                        "Prince Edward Island",
                        "Vancouver Island",
                        "Newfoundland"
                    ]
                ),
                OTDQuestion(
                    category: "Video Games",
                    type: .multipleChoice,
                    difficulty: .medium,
                    text: "What is the name of the 8th installment in the "
                        + "Fire Emblem series?",
                    correctAnswer: "The Sacred Stones",
                    incorrectAnswers: [
                        "The Blazing Blade",
                        "Awakening",
                        "Path of Radiance"
                    ]
                ),
                OTDQuestion(
                    category: "Art",
                    type: .trueOrFalse,
                    difficulty: .easy,
                    text: "Leonardo da Vinci’s Mona Lisa does not have "
                        + "eyebrows?",
                    correctAnswer: "True",
                    incorrectAnswers: ["False"]
                ),
                OTDQuestion(
                    category: "Music",
                    type: .multipleChoice,
                    difficulty: .hard,
                    text: "What K-pop girl group is Sana Minatozaki from?",
                    correctAnswer: "Twice",
                    incorrectAnswers: ["Blackpink", "Red Velvet", "Itzy"]
                )
            ]
        )
        
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 0)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 0)
        XCTAssertEqual(triviaQuiz.score, 0)
        
        triviaQuiz.submitAnswer("Baffin Island", at: 0)
        XCTAssertTrue(triviaQuiz.questions[0].isAnswered)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 1)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 0)
        XCTAssertEqual(triviaQuiz.score, 150)
        
        triviaQuiz.submitAnswer("Prince Edward Island", at: 0)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 0)
        
        triviaQuiz.submitAnswer("The Sacred Stones", at: 1)
        XCTAssertTrue(triviaQuiz.questions[1].isAnswered)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 2)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 0)
        XCTAssertEqual(triviaQuiz.score, 250)
        
        triviaQuiz.submitAnswer("False", at: 2)
        XCTAssertTrue(triviaQuiz.questions[2].isAnswered)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 2)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 1)
        XCTAssertEqual(triviaQuiz.score, 250)
        
        triviaQuiz.submitAnswer("TWICE", at: 3)
        XCTAssertFalse(triviaQuiz.questions[3].isAnswered)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 1)
        
        triviaQuiz.submitAnswer(nil, at: 3)
        XCTAssertTrue(triviaQuiz.questions[3].isAnswered)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 2)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 2)
        XCTAssertEqual(triviaQuiz.score, 250)
    }
}
