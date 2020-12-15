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
                )
            ]
        )
        XCTAssertEqual(triviaQuiz.questionCount, 3)
        XCTAssertEqual(triviaQuiz.currentQuestionIndex, 0)
        XCTAssertEqual(triviaQuiz.currentQuestion.difficulty, .hard)
        XCTAssertEqual(triviaQuiz.answers, [])
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 0)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 0)
        XCTAssertEqual(triviaQuiz.score, 0)
        
        triviaQuiz.advanceToNextQuestion()
        XCTAssertEqual(triviaQuiz.currentQuestionIndex, 0)
        
        triviaQuiz.submitAnswer("Baffin Island")
        XCTAssertEqual(triviaQuiz.answers.count, 1)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 1)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 0)
        XCTAssertEqual(triviaQuiz.score, 3)
        
        triviaQuiz.submitAnswer("Prince Edward Island")
        XCTAssertEqual(triviaQuiz.answers.count, 1)
        
        triviaQuiz.advanceToNextQuestion()
        XCTAssertEqual(triviaQuiz.currentQuestionIndex, 1)
        XCTAssertEqual(triviaQuiz.currentQuestion.difficulty, .medium)
        
        triviaQuiz.submitAnswer("The Sacred Stones")
        XCTAssertEqual(triviaQuiz.answers.count, 2)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 2)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 0)
        XCTAssertEqual(triviaQuiz.score, 5)
        
        triviaQuiz.advanceToNextQuestion()
        XCTAssertEqual(triviaQuiz.currentQuestionIndex, 2)
        XCTAssertEqual(triviaQuiz.currentQuestion.difficulty, .easy)
        
        triviaQuiz.submitAnswer("False")
        XCTAssertEqual(triviaQuiz.answers.count, 3)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 2)
        XCTAssertEqual(triviaQuiz.incorrectAnswerCount, 1)
        XCTAssertEqual(triviaQuiz.score, 5)
        
        triviaQuiz.advanceToNextQuestion()
        XCTAssertEqual(triviaQuiz.currentQuestionIndex, 2)
    }
}
