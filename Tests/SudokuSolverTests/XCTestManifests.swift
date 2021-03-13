import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(FullPuzzleSolutionTests.allTests),
		testCase(NakedSingleTests.allTests),
		testCase(PuzzleTests.allTests),
	]
}
#endif
