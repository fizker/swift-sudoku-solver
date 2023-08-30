import XCTest
@testable import SudokuSolver

func XCTAssertIsSolved(_ puzzle: Puzzle, file: StaticString = #filePath, line: UInt = #line) {
	XCTAssertTrue(puzzle.isSolved, "\n" + puzzle.debugDescription, file: file, line: line)
}
