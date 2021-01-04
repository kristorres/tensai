import SwiftUI

/// A view to see the result of a trivia quiz.
struct TriviaQuizResultView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- State management
    // -------------------------------------------------------------------------
    
    /// The round with a quiz of trivia questions.
    @ObservedObject var triviaQuizRound: TriviaQuizRound
    
    /// The view router.
    @EnvironmentObject private var viewRouter: ViewRouter
    
    // -------------------------------------------------------------------------
    // MARK:- Other properties
    // -------------------------------------------------------------------------
    
    /// The minimum value that indicates whether the player passed the trivia
    /// quiz.
    private let passingThreshold = 0.7
    
    var body: some View {
        let correctAnswerCount = triviaQuizRound.correctAnswerCount
        let questionCount = triviaQuizRound.questions.count
        
        return VStack(spacing: 12) {
            Spacer()
            Image(systemName: symbolName)
                .font(.system(size: 160))
                .foregroundColor(scoreColor)
                .padding()
            Text(primaryMessage).font(.largeTitle).fontWeight(.black)
            Text(secondaryMessage).font(.title)
            Text("\(correctAnswerCount)/\(questionCount)")
                .font(.system(size: 64, weight: .heavy))
                .foregroundColor(scoreColor)
            Text("Score: \(triviaQuizRound.score)")
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
            if !playerPassed {
                Button(action: {}) {
                    Text("RETRY")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding()
                        .frame(maxWidth: DrawingConstants.maximumButtonWidth)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
            Button(action: goToConfigView) {
                Text("START A NEW QUIZ")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding()
                    .frame(maxWidth: DrawingConstants.maximumButtonWidth)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
        }
            .padding()
    }
    
    /// Indicates whether the player passed the trivia quiz.
    private var playerPassed: Bool {
        let correctAnswerCount = Double(triviaQuizRound.correctAnswerCount)
        let questionCount = Double(triviaQuizRound.questions.count)
        return correctAnswerCount / questionCount >= passingThreshold
    }
    
    /// The primary message.
    private var primaryMessage: String {
        playerPassed ? "Congratulations!" : "Ooh, sorry!"
    }
    
    /// The score color.
    private var scoreColor: Color {
        playerPassed ? .blue : .red
    }
    
    /// The secondary message.
    private var secondaryMessage: String {
        playerPassed ? "You are a true genius!" : "Better luck next time."
    }
    
    /// The SF symbol name.
    private var symbolName: String {
        "\(playerPassed ? "check" : "x")mark.circle.fill"
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Private method
    // -------------------------------------------------------------------------
    
    /// Sends the player back to the *Start a New Quiz* view.
    private func goToConfigView() {
        withAnimation {
            viewRouter.currentViewKey = .triviaQuizConfig
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Nested struct
    // -------------------------------------------------------------------------
    
    /// An internal struct that contains drawing constants.
    private struct DrawingConstants {
        
        /// The maximum width of a button.
        static let maximumButtonWidth = CGFloat(400)
    }
}

#if DEBUG
struct TriviaQuizResultView_Previews: PreviewProvider {
    static var previews: some View {
        let view = TriviaQuizResultView(
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
            .environmentObject(ViewRouter())
        
        return DevicePreviewGroup(name: "Trivia Quiz Result View", view: view)
    }
}
#endif
