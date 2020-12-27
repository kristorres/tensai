import SwiftUI

/// A view to answer questions in a trivia quiz.
struct TriviaQuizView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- State management
    // -------------------------------------------------------------------------
    
    /// The round with a quiz of trivia questions.
    @ObservedObject var triviaQuizRound: TriviaQuizRound
    
    /// The view router.
    @ObservedObject var viewRouter = ViewRouter()
    
    /// The index of the current question.
    @State private var currentQuestionIndex = 0
    
    // -------------------------------------------------------------------------
    // MARK:- Other properties
    // -------------------------------------------------------------------------
    
    /// The delay before the next question is displayed (in seconds).
    private let delayForNextQuestion = 3.0
    
    /// The current question.
    private var currentQuestion: TriviaQuiz.Question {
        triviaQuizRound.questions[currentQuestionIndex]
    }
    
    var body: some View {
        let questionNumber = currentQuestionIndex + 1
        let questionCount = triviaQuizRound.questions.count
        
        return VStack(alignment: .leading) {
            HStack {
                Text(currentQuestion.category).fontWeight(.bold)
                Spacer()
                difficultyStarMeter()
            }
                .font(.callout)
                .foregroundColor(.gray)
                .padding(.bottom, 6)
            Text("Question \(questionNumber)/\(questionCount)")
                .font(.largeTitle)
                .fontWeight(.black)
            Divider()
            Text(currentQuestion.text).font(.title2).fontWeight(.heavy)
            Spacer()
            VStack(spacing: 12) {
                ForEach(currentQuestion.possibleAnswers, id: \.self) { answer in
                    self.answerButton(for: answer)
                }
            }
        }
            .padding()
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Private methods
    // -------------------------------------------------------------------------
    
    /// Creates a button that contains the specified answer.
    ///
    /// If that answer is selected by the player, then the button will have a
    /// color fill. Otherwise, the button will have an outline.
    ///
    /// - Parameter answer: The answer on the button.
    ///
    /// - Returns: The answer button.
    @ViewBuilder private func answerButton(for answer: String) -> some View {
        if let selectedAnswer = currentQuestion.selectedAnswer,
            selectedAnswer == answer {
            containedAnswerButton(for: answer)
        }
        else {
            outlinedAnswerButton(for: answer)
        }
    }
    
    /// Returns the current color of the button that contains the specified
    /// answer.
    ///
    /// - Parameter answer: The answer on the button.
    ///
    /// - Returns: The button color.
    private func answerButtonColor(for answer: String) -> Color {
        if let selectedAnswer = currentQuestion.selectedAnswer {
            if selectedAnswer != answer {
                return .gray
            }
            if selectedAnswer == currentQuestion.correctAnswer {
                return .green
            }
            return .red
        }
        return .blue
    }
    
    /// Creates a color-filled button that contains the specified answer.
    ///
    /// - Parameter answer: The answer on the button.
    ///
    /// - Returns: The answer button.
    private func containedAnswerButton(for answer: String) -> some View {
        let buttonColor = answerButtonColor(for: answer)
        let buttonBorder = RoundedRectangle(
            cornerRadius: DrawingConstants.answerButtonCornerRadius
        )
        return Button(action: { self.selectAnswer(answer) }) {
            Text(answer)
                .font(.headline)
                .padding()
                .frame(maxWidth: DrawingConstants.maximumAnswerButtonWidth)
                .foregroundColor(.white)
                .background(buttonColor)
                .clipShape(buttonBorder)
        }
            .disabled(currentQuestion.selectedAnswer != nil)
    }
    
    /// Creates a horizontal star meter that represents the difficulty level of
    /// the current question.
    ///
    /// - Returns: The difficulty star meter.
    private func difficultyStarMeter() -> some View {
        let starCount: Int
        switch currentQuestion.difficulty {
        case .easy: starCount = 1
        case .medium: starCount = 2
        case .hard: starCount = 3
        }
        return HStack {
            ForEach(0 ..< starCount, id: \.self) { _ in
                Image(systemName: "star.fill")
            }
            ForEach(0 ..< 3 - starCount, id: \.self) { _ in
                Image(systemName: "star")
            }
        }
    }
    
    /// Creates an outlined button that contains the specified answer.
    ///
    /// - Parameter answer: The answer on the button.
    ///
    /// - Returns: The answer button.
    private func outlinedAnswerButton(for answer: String) -> some View {
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
                .padding()
                .frame(maxWidth: DrawingConstants.maximumAnswerButtonWidth)
                .foregroundColor(buttonColor)
                .overlay(buttonBorder)
        }
            .disabled(currentQuestion.selectedAnswer != nil)
    }
    
    /// Selects the specified answer to the current question, and advances to
    /// the next question.
    ///
    /// - Parameter answer: The player’s answer to the current question.
    private func selectAnswer(_ answer: String) {
        
        triviaQuizRound.submitAnswer(answer, at: currentQuestionIndex)
        
        let questionNumber = currentQuestionIndex + 1
        let questionCount = triviaQuizRound.questions.count
        if questionNumber == questionCount {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delayForNextQuestion) {
            currentQuestionIndex += 1
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
