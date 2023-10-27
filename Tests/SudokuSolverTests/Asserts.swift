import XCTest
@testable import SudokuSolver

func XCTAssertIsSolved(_ puzzle: Puzzle, file: StaticString = #filePath, line: UInt = #line) {
	XCTAssertTrue(puzzle.isSolved, "\n" + puzzle.debugDescription, file: file, line: line)
}

func XCTAssertCanSolve(_ dsl: String, solvers: [Algorithm] = .all, file: StaticString = #filePath, line: UInt = #line) {
	var puzzle: Puzzle? = nil
	XCTAssertNoThrow(puzzle = try Puzzle(dsl: dsl), dsl)
	guard let puzzle
	else { return }

	let solved = solvers.solve(puzzle)
	XCTAssertTrue(solved.isSolved, "\n" + solved.debugDescription, file: file, line: line)
}
