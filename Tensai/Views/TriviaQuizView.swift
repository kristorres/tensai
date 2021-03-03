import SwiftUI

/// A view to answer questions in a trivia quiz.
///
/// The player will immediately know if he/she answered a question correctly or
/// incorrectly. Regardless, the next question will be displayed three seconds
/// after the current question is answered.
struct TriviaQuizView: View {
    
    // -------------------------------------------------------------------------
    // MARK:- State management
    // -------------------------------------------------------------------------
    
    /// The view model that binds this view to a quiz of trivia questions.
    @ObservedObject var viewModel: TriviaQuizViewModel
    
    /// The global app state.
    @EnvironmentObject private var appState: AppState
    
    /// The timer.
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    /// The time remaining for the player to answer the current question
    /// (in seconds).
    @State private var timeRemaining = 15.0
    
    /// The index of the current question.
    @State private var currentQuestionIndex = 0 {
        didSet {
            restartTimer()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK:- Other properties
    // -------------------------------------------------------------------------
    
    /// The time limit for each question in the trivia quiz (in seconds).
    private let timeLimit = 15.0
    
    /// The delay before the next question is displayed (in seconds).
    private let delayForNextQuestion = 3.0
    
    var body: some View {
        let questionNumber = currentQuestionIndex + 1
        let questionCount = viewModel.questions.count
        
        return VStack(alignment: .leading, spacing: 6) {
            ProgressView(value: timeRemaining / timeLimit)
                .progressViewStyle(LinearProgressViewStyle(tint: timerColor))
            Text("Score: \(viewModel.score)")
                .font(.title)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 12)
            HStack {
                Text(currentQuestion.category).fontWeight(.bold)
                Spacer()
                difficultyStarMeter
            }
                .font(.callout)
                .foregroundColor(.secondary)
            Text("Question \(questionNumber)/\(questionCount)")
                .font(.largeTitle)
                .fontWeight(.black)
            Divider()
            Text(currentQuestion.text).font(.title2).fontWeight(.heavy)
            Spacer()
            VStack(spacing: 12) {
                ForEach(currentQuestion.possibleAnswers, id: \.self) {
                    self.answerButton(for: $0)
                }
            }
        }
            .padding()
            .onReceive(timer) { _ in
                if self.timeRemaining > 0 {
                    withAnimation(.linear) {
                        self.timeRemaining -= 1
                        if (self.timeRemaining == 0) {
                            self.selectAnswer(nil)
                        }
                    }
                }
            }
    }
    
    /// The current question.
    private var currentQuestion: TriviaQuiz.Question {
        viewModel.questions[currentQuestionIndex]
    }
    
    /// The horizontal star meter that represents the difficulty level of the
    /// current question.
    private var difficultyStarMeter: some View {
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
    
    /// The timer color.
    private var timerColor: Color {
        timeRemaining > 5.0 ? .green : .red
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
                return .secondary
            }
            if selectedAnswer == currentQuestion.correctAnswer {
                return .green
            }
            return .red
        }
        if currentQuestion.isAnswered {
            if answer == currentQuestion.correctAnswer {
                return .green
            }
            return .secondary
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
        return Button(action: { self.selectAnswer(answer) }) {
            Text(answer)
                .font(.headline)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardify(
                    backgroundColor: buttonColor,
                    borderColor: buttonColor
                )
        }
            .disabled(currentQuestion.isAnswered)
    }
    
    /// Creates an outlined button that contains the specified answer.
    ///
    /// - Parameter answer: The answer on the button.
    ///
    /// - Returns: The answer button.
    private func outlinedAnswerButton(for answer: String) -> some View {
        let buttonColor = answerButtonColor(for: answer)
        return Button(action: { self.selectAnswer(answer) }) {
            Text(answer)
                .font(.headline)
                .foregroundColor(buttonColor)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardify(
                    backgroundColor: Color("Option Background"),
                    borderColor: buttonColor
                )
        }
            .disabled(currentQuestion.isAnswered)
    }
    
    /// Restarts the timer.
    private func restartTimer() {
        timeRemaining = timeLimit
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    /// Stops the timer.
    private func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    /// Selects the specified answer to the current question, and advances to
    /// the next question.
    ///
    /// - Parameter answer: The player’s answer to the current question.
    private func selectAnswer(_ answer: String?) {
        viewModel.submitAnswer(answer, at: currentQuestionIndex)
        stopTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + delayForNextQuestion) {
            let questionNumber = currentQuestionIndex + 1
            let questionCount = viewModel.questions.count
            if questionNumber == questionCount {
                self.appState.currentViewKey = .triviaQuizResult(viewModel)
                return
            }
            currentQuestionIndex += 1
        }
    }
}

#if DEBUG
struct TriviaQuizView_Previews: PreviewProvider {
    static var previews: some View {
        let view = TriviaQuizView(
            viewModel: TriviaQuizViewModel(
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
            .environmentObject(AppState())
        
        return DevicePreviewGroup(name: "Trivia Quiz View", view: view)
    }
}
#endif
