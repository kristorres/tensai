import Foundation

/// The [Open Trivia Database](https://opentdb.com) namespace.
struct OpenTriviaDB {
    private init() {}
    
    /// A query for fetching trivia questions from the
    /// [Open Trivia Database](https://opentdb.com).
    struct Query: Codable {
        
        /// Creates a default database query.
        init() {}
        
        /// Creates a database query with the given “property list.”
        ///
        /// If the “property list” is `nil` or it cannot be decoded, then this
        /// initializer will return `nil`.
        ///
        /// - Parameter propertyList: The “property list” to decode.
        init?(propertyList: Data?) {
            guard let propertyList = propertyList else {
                return nil
            }
            
            guard let query = try? JSONDecoder().decode(
                Query.self,
                from: propertyList
            ) else {
                return nil
            }
            
            self = query
        }
        
        /// The default number of questions in a trivia quiz.
        private static let defaultQuestionCount = 10
        
        /// The number of questions in a trivia quiz.
        var questionCount = Self.defaultQuestionCount
        
        /// The category ID.
        var categoryID: Int?
        
        /// The question type.
        var questionType: OTDBResponse.Question.Kind?
        
        /// The “property list” representation of this database query.
        var propertyList: Data? {
            try? JSONEncoder().encode(self)
        }
        
        /// The API URL.
        var url: URL? {
            var urlStringParts = [
                "https://opentdb.com/api.php",
                "?amount=\(questionCount)"
            ]
            
            if let categoryID = self.categoryID {
                urlStringParts.append("&category=\(categoryID)")
            }
            if let questionType = self.questionType {
                urlStringParts.append("&type=\(questionType.rawValue)")
            }
            
            return URL(string: urlStringParts.joined())
        }
    }
}
