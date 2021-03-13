import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(FullPuzzleSolutionTests.allTests),
		testCase(LastRemainingCellTests.allTests),
		testCase(PuzzleTests.allTests),
	]
}
#endif
