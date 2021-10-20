import XCTest
@testable import Tensai

final class DataCenterTests: XCTestCase {
    
    func testNegativeQuestionCount() async {
        await testInvalidQuestionCount(-1)
    }
    
    func testZeroQuestionCount() async {
        await testInvalidQuestionCount(0)
    }
    
    func testRequestTimedOut() async {
        let urlSessionConfiguration = URLSessionConfiguration.noCaching
        urlSessionConfiguration.timeoutIntervalForResource = 0.0001
        let urlSession = URLSession(configuration: urlSessionConfiguration)
        let dataCenter = DataCenter(urlSession: urlSession)
        
        let query = OpenTriviaDB.Query()
        
        await testCreateTriviaQuizFail(
            with: query,
            dataCenter: dataCenter,
            expectedError: .requestTimedOut
        )
    }
    
    func testInvalidCategory() async {
        var query = OpenTriviaDB.Query()
        query.categoryID = -1
        
        await testCreateTriviaQuizFail(
            with: query,
            expectedError: .notEnoughQuestions
        )
    }
    
    func testTriviaQuizFromDefaultQuery() async throws {
        let query = OpenTriviaDB.Query()
        
        try await testCreateTriviaQuizSuccess(with: query) {
            XCTAssertEqual($0.questions.count, 10)
        }
    }
    
    func testTriviaQuizWithCustomQuestionCountOnly() async throws {
        var query = OpenTriviaDB.Query()
        query.questionCount = 50
        
        try await testCreateTriviaQuizSuccess(with: query) {
            XCTAssertEqual($0.questions.count, 50)
        }
    }
    
    func testTriviaQuizWithCategory() async throws {
        var query = OpenTriviaDB.Query()
        query.categoryID = 9
        
        try await testCreateTriviaQuizSuccess(with: query) { triviaQuiz in
            let categories = triviaQuiz.questions.map {
                $0.category
            }
            let uniqueCategories = Set<String>(categories)
            
            XCTAssertEqual(uniqueCategories.count, 1)
        }
    }
    
    func testTriviaQuizWithQuestionType() async throws {
        var query = OpenTriviaDB.Query()
        query.questionType = .multipleChoice
        
        try await testCreateTriviaQuizSuccess(with: query) { triviaQuiz in
            let questionTypes = triviaQuiz.questions.map {
                $0.type
            }
            let uniqueQuestionTypes = Set<OpenTriviaDB.Question.Kind>(
                questionTypes
            )
            
            XCTAssertEqual(uniqueQuestionTypes.count, 1)
        }
    }
    
    private func testCreateTriviaQuizFail(
        with query: OpenTriviaDB.Query,
        dataCenter: DataCenter = .shared,
        expectedError: DataCenter.APIError
    ) async {
        do {
            let _ = try await dataCenter.createTriviaQuiz(with: query)
            XCTFail("No error thrown.")
        }
        catch let error as DataCenter.APIError where error == expectedError {
        }
        catch {
            XCTFail("Incorrect error thrown.")
        }
    }
    
    private func testCreateTriviaQuizSuccess(
        with query: OpenTriviaDB.Query,
        testTriviaQuiz: (TriviaQuiz) -> Void
    ) async throws {
        let triviaQuiz = try await DataCenter.shared.createTriviaQuiz(
            with: query
        )
        
        testTriviaQuiz(triviaQuiz)
    }
    
    private func testInvalidQuestionCount(_ questionCount: Int) async {
        var query = OpenTriviaDB.Query()
        query.questionCount = questionCount
        
        await testCreateTriviaQuizFail(
            with: query,
            expectedError: .invalidQuestionCount
        )
    }
}
