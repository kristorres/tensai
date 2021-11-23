import XCTest
@testable import Tensai

final class OTDBQueryTests: XCTestCase {
    
    func testDefaultQueryURL() {
        let query = OpenTriviaDB.Query()
        
        let expectedURL = URL(string: "https://opentdb.com/api.php?amount=10")
        XCTAssertEqual(query.url, expectedURL)
    }
    
    func testQueryURLWithCustomQuestionCountOnly() {
        var query = OpenTriviaDB.Query()
        query.questionCount = 50
        
        let expectedURL = URL(string: "https://opentdb.com/api.php?amount=50")
        XCTAssertEqual(query.url, expectedURL)
    }
    
    func testQueryURLWithCategoryID() {
        var query = OpenTriviaDB.Query()
        query.categoryID = 9
        
        let expectedURL = URL(
            string: "https://opentdb.com/api.php?amount=10&category=9"
        )
        XCTAssertEqual(query.url, expectedURL)
    }
    
    func testQueryURLWithQuestionType() {
        var query = OpenTriviaDB.Query()
        query.questionType = .multipleChoice
        
        let expectedURL = URL(
            string: "https://opentdb.com/api.php?amount=10&type=multiple"
        )
        XCTAssertEqual(query.url, expectedURL)
    }
    
    func testQueryURLWithAllArguments() {
        var query = OpenTriviaDB.Query()
        query.questionCount = 50
        query.categoryID = 9
        query.questionType = .multipleChoice
        
        let expectedURLStringParts = [
            "https://opentdb.com/api.php",
            "?amount=50",
            "&category=9",
            "&type=multiple"
        ]
        let expectedURL = URL(string: expectedURLStringParts.joined())
        XCTAssertEqual(query.url, expectedURL)
    }
    
    func testQueryURLFromPropertyList() {
        let json = """
        {
            "questionCount": 50,
            "categoryID": 9,
            "questionType": "multiple"
        }
        """.data(using: .utf8)!
        let query = OpenTriviaDB.Query(propertyList: json)
        
        let expectedURLStringParts = [
            "https://opentdb.com/api.php",
            "?amount=50",
            "&category=9",
            "&type=multiple"
        ]
        let expectedURL = URL(string: expectedURLStringParts.joined())
        XCTAssertEqual(query?.url, expectedURL)
    }
    
    func testIncorrectPropertyListFormat() {
        let json = """
        {
            "categoryID": 9,
            "questionType": "multiple"
        }
        """.data(using: .utf8)!
        
        XCTAssertNil(OpenTriviaDB.Query(propertyList: json))
    }
}
