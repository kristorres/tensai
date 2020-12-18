import SwiftUI

/// A view to answer questions in a trivia quiz.
struct TriviaQuizView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- Properties
    // -------------------------------------------------------------------------
    
    /// The round with a quiz of trivia questions.
    @ObservedObject var triviaQuizRound: TriviaQuizRound
    
    /// The view router.
    @ObservedObject var viewRouter = ViewRouter()
    
    /// The player’s selected answer to the current question.
    @State private var selectedAnswer: String?
    
    var body: some View {
        let questionNumber = triviaQuizRound.currentQuestionNumber
        let questionCount = triviaQuizRound.questionCount
        let question = triviaQuizRound.currentQuestion
        
        return VStack(alignment: .leading) {
            Text("Question \(questionNumber)/\(questionCount)")
                .font(.largeTitle)
                .fontWeight(.black)
            Divider()
            Text(question.text).font(.title)
            Spacer()
            VStack(spacing: 12) {
                ForEach(question.possibleAnswers, id: \.self) { answer in
                    self.createAnswerButton(for: answer)
                }
            }
        }
            .padding()
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Private methods
    // -------------------------------------------------------------------------
    
    /// Returns the current color of the button that contains the specified
    /// answer.
    ///
    /// - Parameter answer: The answer on the button.
    ///
    /// - Returns: The button color.
    private func answerButtonColor(for answer: String) -> Color {
        if let selectedAnswer = selectedAnswer {
            if selectedAnswer != answer {
                return .gray
            }
            if selectedAnswer == triviaQuizRound.currentQuestion.correctAnswer {
                return .green
            }
            return .red
        }
        return .blue
    }
    
    /// Creates a button that contains the specified answer.
    ///
    /// - Parameter answer: The answer on the button.
    ///
    /// - Returns: The answer button.
    private func createAnswerButton(for answer: String) -> some View {
        let buttonColor = answerButtonColor(for: answer)
        let buttonBorder = RoundedRectangle(
            cornerRadius: DrawingConstants.answerButtonCornerRadius
        )
            .stroke(
                buttonColor,
                lineWidth: DrawingConstants.answerButtonBorderWidth
            )
        return Button(action: { self.selectAnswer(answer) }) {
            Text(answer)
                .font(.headline)
                .foregroundColor(buttonColor)
                .padding()
                .frame(maxWidth: DrawingConstants.maximumAnswerButtonWidth)
                .overlay(buttonBorder)
        }
            .disabled(selectedAnswer != nil)
    }
    
    /// Selects the specified answer to the current question, and advances to
    /// the next question.
    ///
    /// - Parameter answer: The player’s answer to the current question.
    private func selectAnswer(_ answer: String) {
        
        selectedAnswer = answer
        triviaQuizRound.submitAnswer(answer)
        
        let questionNumber = triviaQuizRound.currentQuestionNumber
        let questionCount = triviaQuizRound.questionCount
        if questionNumber == questionCount {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            triviaQuizRound.advanceToNextQuestion()
            selectedAnswer = nil
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Nested struct
    // -------------------------------------------------------------------------
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The border width for each answer button.
        static let answerButtonBorderWidth = CGFloat(4)
        
        /// The corner radius for each answer button.
        static let answerButtonCornerRadius = CGFloat(16)
        
        /// The maximum width of each answer button.
        static let maximumAnswerButtonWidth = CGFloat.infinity
    }
}

#if DEBUG
struct TriviaQuizView_Previews: PreviewProvider {
    static var previews: some View {
        let viewName = "Trivia Quiz View"
        let view = TriviaQuizView(
            triviaQuizRound: TriviaQuizRound(
                triviaQuiz: TriviaQuiz(
                    questions: [
                        OTDQuestion(
                            category: "General Knowledge",
                            type: .multipleChoice,
                            difficulty: .easy,
                            text: "What word represents the letter T in the "
                                + "NATO phonetic alphabet?",
                            correctAnswer: "Tango",
                            incorrectAnswers: [
                                "Target",
                                "Taxi",
                                "Turkey"
                            ]
                        )
                    ]
                )
            )
        )
        return Group {
            view
                .previewDevice("iPhone SE (1st generation)")
                .previewDisplayName("\(viewName) — iPhone SE 1")
            view
                .previewDevice("iPhone X")
                .previewDisplayName("\(viewName) — iPhone X")
            view
                .previewDevice("iPhone X")
                .preferredColorScheme(.dark)
                .previewDisplayName("\(viewName) — iPhone X (Dark Mode)")
            view
                .previewDevice("iPad Air (4th generation)")
                .previewDisplayName("\(viewName) — iPad Air 4")
        }
    }
}
#endif
