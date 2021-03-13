import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(LastRemainingCellTests.allTests),
		testCase(PuzzleTests.allTests),
	]
}
#endif
