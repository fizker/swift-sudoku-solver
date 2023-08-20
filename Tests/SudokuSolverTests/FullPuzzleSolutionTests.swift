import XCTest

import SudokuSolver

func XCTAssertIsSolved(_ puzzle: Puzzle) {
	XCTAssertTrue(puzzle.isSolved, puzzle.description)
}

func XCTAssertIsSolved(_ puzzle: Puzzle, _ description: String) {
	XCTAssertTrue(puzzle.isSolved, description)
}

class FullPuzzleSolutionTests: XCTestCase {
	func test__solve__puzzleWith4MissingValues() throws {
		let puzzle = try Puzzle(dsl: """
		831 764 259
		695 281 374
		-72 5-3 861

		153 829 647
		-87 4-6 132
		246 137 598

		768 915 423
		514 372 986
		329 648 715
		""")

		let solved = solve(puzzle)
		XCTAssertIsSolved(solved)
	}

	func test__solve__puzzleIsUnsolvable__theSolverReturnsThePuzzleUnsolved() throws {
		let puzzle = try Puzzle(dsl: """
		--1 --4 -3-
		9-- --- --6
		3-4 --- ---

		-7- --- 6--
		--- -7- -5-
		--- 35- -9-

		--- 1-- 3-4
		--6 --9 2-7
		-42 8-7 9--
		""")

		let solved = solve(puzzle)
		XCTAssertFalse(solved.isSolved)
	}

	static let allTests = [
		("test__solve__puzzleWith4MissingValues", test__solve__puzzleWith4MissingValues),
		("test__solve__puzzleIsUnsolvable__theSolverReturnsThePuzzleUnsolved", test__solve__puzzleIsUnsolvable__theSolverReturnsThePuzzleUnsolved)
	]
}
