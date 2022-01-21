import XCTest
@testable import Tensai

final class TriviaQuizTests: XCTestCase {
    private let newTriviaQuiz = TriviaQuiz(
        questions: [
            OTDBResponse.Question(
                "What K-pop girl group is Sana Minatozaki from?",
                category: "Music",
                difficulty: .hard,
                type: .multipleChoice,
                correctAnswer: "Twice",
                incorrectAnswers: ["Blackpink", "Red Velvet", "Itzy"]
            ),
            OTDBResponse.Question(
                "In &quot;The Hobbit&quot;, who kills Smaug?",
                category: "Books",
                difficulty: .medium,
                type: .multipleChoice,
                correctAnswer: "Bard the Bowman",
                incorrectAnswers: ["Bilbo Baggins", "Gandalf", "Elrond"]
            ),
            OTDBResponse.Question(
                "Leonardo da Vinci’s Mona Lisa does not have eyebrows.",
                category: "Art",
                difficulty: .easy,
                type: .trueOrFalse,
                correctAnswer: "True",
                incorrectAnswers: ["False"]
            ),
            OTDBResponse.Question(
                "Which current Dodger won N.L. MVP honors in 2013?",
                category: "Sports",
                difficulty: .medium,
                type: .multipleChoice,
                correctAnswer: "Clayton Kershaw",
                incorrectAnswers: [
                    "Justin Turner",
                    "Albert Pujols",
                    "Kenley Jansen"
                ]
            )
        ]
    )
    
    func testInit() {
        XCTAssertEqual(newTriviaQuiz.questions.count, 4)
        XCTAssertTrue(
            newTriviaQuiz.questions.allSatisfy {
                $0.selectedAnswer == nil && !$0.isAnswered && $0.isActive
            }
        )
        XCTAssertEqual(
            newTriviaQuiz.questions[1].description,
            "In \"The Hobbit\", who kills Smaug?"
        )
        XCTAssertEqual(
            newTriviaQuiz.questions[0].possibleAnswers.sorted(),
            ["Blackpink", "Itzy", "Red Velvet", "Twice"]
        )
        XCTAssertEqual(
            newTriviaQuiz.questions[2].possibleAnswers,
            ["True", "False"]
        )
        
        XCTAssertEqual(newTriviaQuiz.correctAnswerCount, 0)
        XCTAssertEqual(newTriviaQuiz.currentQuestionIndex, 0)
    }
    
    func testSubmitCorrectAnswer() {
        submitAnswer("Twice", correctAnswerCount: 1)
    }
    
    func testSubmitWrongAnswer() {
        submitAnswer("Blackpink", correctAnswerCount: 0)
    }
    
    func testSubmitNoAnswer() {
        submitAnswer(nil, correctAnswerCount: 0)
    }
    
    func testSubmitSecondAnswer() {
        var triviaQuiz = newTriviaQuiz
        triviaQuiz.submitAnswer("Twice")
        triviaQuiz.submitAnswer("Blackpink")
        
        XCTAssertEqual(triviaQuiz.questions[0].selectedAnswer, "Twice")
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 1)
        XCTAssertEqual(triviaQuiz.currentQuestionIndex, 0)
    }
    
    func testMarkUnansweredQuestionAsDone() {
        var triviaQuiz = newTriviaQuiz
        triviaQuiz.markCurrentQuestionAsDone()
        
        XCTAssertTrue(triviaQuiz.questions[0].isActive)
    }
    
    func testMarkAnsweredQuestionAsDone() {
        var triviaQuiz = newTriviaQuiz
        triviaQuiz.submitAnswer("Twice")
        triviaQuiz.markCurrentQuestionAsDone()
        
        XCTAssertFalse(triviaQuiz.questions[0].isActive)
        XCTAssertEqual(triviaQuiz.currentQuestionIndex, 1)
    }
    
    func testFinishTriviaQuiz() {
        var triviaQuiz = newTriviaQuiz
        let selectedAnswers = [
            "Twice",
            "Bilbo Baggins",
            nil,
            "Clayton Kershaw"
        ]
        for answer in selectedAnswers {
            triviaQuiz.submitAnswer(answer)
            triviaQuiz.markCurrentQuestionAsDone()
        }
        
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 2)
        XCTAssertNil(triviaQuiz.currentQuestionIndex)
        
        triviaQuiz.submitAnswer(nil)
        triviaQuiz.markCurrentQuestionAsDone()
        
        XCTAssertEqual(triviaQuiz.correctAnswerCount, 2)
        XCTAssertNil(triviaQuiz.currentQuestionIndex)
    }
    
    private func submitAnswer(_ answer: String?, correctAnswerCount: Int) {
        var triviaQuiz = newTriviaQuiz
        triviaQuiz.submitAnswer(answer)
        
        let question = triviaQuiz.questions[0]
        XCTAssertEqual(question.selectedAnswer, answer)
        XCTAssertTrue(question.isAnswered)
        XCTAssertTrue(question.isActive)
        
        XCTAssertEqual(triviaQuiz.correctAnswerCount, correctAnswerCount)
        XCTAssertEqual(triviaQuiz.currentQuestionIndex, 0)
    }
}
