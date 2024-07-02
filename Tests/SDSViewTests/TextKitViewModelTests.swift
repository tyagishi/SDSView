@testable import SDSView
import XCTest
import Combine
import SDSNSUIBridge

final class TextKitViewModelTests: XCTestCase {
    
    @MainActor
    func test_init() async throws {
        let sut = TextKitViewModel()
        XCTAssertNotNil(sut)
    }
    
    @MainActor
    func test_editViaTextView() async throws {
        var cancellables: Set<AnyCancellable> = Set()
        let expectation = expectation(description: "textChanged")
        expectation.assertForOverFulfill = false

        let sut = TextKitViewModel()
        
        var checkString: String = ""
        
        sut.textChanged.sink{ newText in
            checkString = newText
            expectation.fulfill()
        }.store(in: &cancellables)
        
        let (textView, _, _) = sut.textViewFactory("")
        
        textView.nsuiInsertText("Hello!", replacementRange: nil)
        
        await fulfillment(of: [expectation], timeout: 3)
        XCTAssertEqual(checkString, "Hello!")
    }

}
