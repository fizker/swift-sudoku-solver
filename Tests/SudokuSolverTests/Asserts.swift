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

struct TestError: Error, CustomStringConvertible {
	var description: String

	init(_ description: String) {
		self.description = description
	}
}

func running(_ algorithm: Algorithm, on puzzle: Puzzle) throws -> Puzzle {
	guard let solved = algorithm(puzzle)
	else { throw TestError("Failed to solve") }

	return solved
}
