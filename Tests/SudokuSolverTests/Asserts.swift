import XCTest
@testable import SudokuSolver

func XCTAssertIsSolved(_ puzzle: Puzzle, file: StaticString = #filePath, line: UInt = #line) {
	XCTAssertTrue(puzzle.isSolved, """
		Puzzle description:
		\(puzzle.description)
		\(puzzle.cells.filter { !$0.hasValue })
		""",
		file: file,
		line: line
	)
}
