import SwiftUI

/// A view to review questions in a trivia quiz.
///
/// If the player answered any question incorrectly, then the correct answer
/// will be displayed below his/her answer for that question.
struct TriviaQuizReviewView: View {
    
    /// The questions in the trivia quiz.
    let questions: [TriviaQuiz.Question]
    
    /// A binding to the current presentation mode of this view.
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color("Review Background").ignoresSafeArea()
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 12) {
                            ForEach(questions.indices) { index in
                                QuestionCard(question: questions[index])
                            }
                        }
                            .padding()
                    }
                        .frame(maxHeight: .infinity)
                }
            }
                .navigationBarTitle(Text("Review"), displayMode: .large)
                .navigationBarItems(trailing: doneButton)
        }
    }
    
    /// The *Done* button to dismiss this view.
    private var doneButton: some View {
        Button("Done") {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

/// A card that contains a question.
fileprivate struct QuestionCard: View {
    
    /// The question on the card.
    let question: TriviaQuiz.Question
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(question.category).fontWeight(.medium)
                Spacer()
                Text(question.difficulty.rawValue.capitalized)
            }
                .font(.footnote)
                .foregroundColor(.secondary)
            Divider()
            Text(question.text).font(.headline).fontWeight(.heavy)
            if question.selectedAnswer == question.correctAnswer {
                Text("Your Answer: \(question.correctAnswer) ✔︎")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            else {
                if question.selectedAnswer != nil {
                    Text("Your Answer: \(question.selectedAnswer!) ✘")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                Text("Correct Answer: \(question.correctAnswer)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
        }
            .cardify(backgroundColor: Color("Background"))
    }
}

#if DEBUG
struct TriviaQuizReviewView_Previews: PreviewProvider {
    static var previews: some View {
        let view = TriviaQuizReviewView(questions: [
            TriviaQuiz.Question(
                category: "Geography",
                type: .multipleChoice,
                difficulty: .hard,
                text: "What is Canada’s largest island?",
                possibleAnswers: [
                    "Baffin Island",
                    "Newfoundland",
                    "Prince Edward Island",
                    "Vancouver Island"
                ],
                correctAnswer: "Baffin Island",
                selectedAnswer: "Baffin Island",
                isAnswered: true
            ),
            TriviaQuiz.Question(
                category: "Art",
                type: .trueOrFalse,
                difficulty: .easy,
                text: "Leonardo da Vinci’s Mona Lisa does not have eyebrows.",
                possibleAnswers: ["True", "False"],
                correctAnswer: "True",
                selectedAnswer: "False",
                isAnswered: true
            ),
            TriviaQuiz.Question(
                category: "Music",
                type: .multipleChoice,
                difficulty: .hard,
                text: "What K-pop girl group is Sana Minatozaki from?",
                possibleAnswers: ["Blackpink", "Itzy", "Red Velvet", "Twice"],
                correctAnswer: "Twice",
                selectedAnswer: nil,
                isAnswered: true
            )
        ])
        return DevicePreviewGroup(name: "Trivia Quiz Review View", view: view)
    }
}
#endif
