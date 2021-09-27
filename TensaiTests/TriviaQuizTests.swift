import XCTest
@testable import Tensai

final class TriviaQuizTests: XCTestCase {
    
    func testTriviaQuiz() {
        var triviaQuiz = TriviaQuiz(
            questions: [
                OpenTriviaDB.Question(
                    category: "Music",
                    type: .multipleChoice,
                    difficulty: .hard,
                    description: (
                        "What K-pop girl group is Sana Minatozaki from?"
                    ),
                    correctAnswer: "Twice",
                    incorrectAnswers: ["Blackpink", "Red Velvet", "Itzy"]
                ),
                OpenTriviaDB.Question(
                    category: "Books",
                    type: .multipleChoice,
                    difficulty: .medium,
                    description: "In &quot;The Hobbit&quot;, who kills Smaug?",
                    correctAnswer: "Bard the Bowman",
                    incorrectAnswers: [
                        "Bilbo Baggins",
                        "Gandalf",
                        "Elrond"
                    ]
                ),
                OpenTriviaDB.Question(
                    category: "Art",
                    type: .trueOrFalse,
                    difficulty: .easy,
                    description: (
                        "Leonardo da Vinci’s Mona Lisa does not have eyebrows."
                    ),
                    correctAnswer: "True",
                    incorrectAnswers: ["False"]
                )
            ]
        )
        var currentIndex = 0
        
        XCTAssertEqual(triviaQuiz.questions.count, 3)
        XCTAssertTrue(
            triviaQuiz.questions.allSatisfy {
                $0.selectedAnswer == nil && !$0.isAnswered
            }
        )
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 0)
        
        triviaQuiz.submitAnswer("Twice", at: currentIndex)
        XCTAssertEqual(
            triviaQuiz.questions[currentIndex].possibleAnswers.sorted(),
            ["Blackpink", "Itzy", "Red Velvet", "Twice"]
        )
        XCTAssertEqual(
            triviaQuiz.questions[currentIndex].selectedAnswer,
            "Twice"
        )
        XCTAssertTrue(triviaQuiz.questions[currentIndex].isAnswered)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 1)
        
        triviaQuiz.submitAnswer("Twice", at: currentIndex)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 1)
        
        triviaQuiz.submitAnswer("Blackpink", at: currentIndex)
        XCTAssertEqual(
            triviaQuiz.questions[currentIndex].selectedAnswer,
            "Twice"
        )
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 1)
        
        currentIndex += 1
        triviaQuiz.submitAnswer("Bilbo Baggins", at: currentIndex)
        XCTAssertEqual(
            triviaQuiz.questions[currentIndex].description,
            "In \"The Hobbit\", who kills Smaug?"
        )
        XCTAssertNotNil(triviaQuiz.questions[currentIndex].selectedAnswer)
        XCTAssertTrue(triviaQuiz.questions[currentIndex].isAnswered)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 1)
        
        currentIndex += 1
        triviaQuiz.submitAnswer(nil, at: currentIndex)
        XCTAssertEqual(
            triviaQuiz.questions[currentIndex].possibleAnswers,
            ["True", "False"]
        )
        XCTAssertNil(triviaQuiz.questions[currentIndex].selectedAnswer)
        XCTAssertTrue(triviaQuiz.questions[currentIndex].isAnswered)
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 1)
    }
}
