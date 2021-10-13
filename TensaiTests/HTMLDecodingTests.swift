import XCTest
@testable import Tensai

final class HTMLDecodingTests: XCTestCase {
    
    func testHTMLDecoding() {
        let song = "Twice — <b>&quot;I Can&#8217;t Stop Me&quot;</b>"
        XCTAssertEqual(song.htmlDecoded, "Twice — \"I Can’t Stop Me\"")
    }
}
