import XCTest
@testable import SudokuSolver

class NakedSingleTests: XCTestCase {
	func test__singleNakedSingle__solvesThatProblem() throws {
		let puzzle = try Puzzle(dsl: """
			5-- 139 ---
			-21 -87 --9
			-98 -4- 5--

			48- 7-- 6--
			-3- 8-- -57
			2-- -9- -14

			-65 91- ---
			943 --8 -65
			7-2 --- --8
			"""
		)

		let solved = nakedSingle(puzzle: puzzle)
		XCTAssertEqual(solved.description, """
			57- 139 ---
			-21 -87 --9
			-98 -4- 5--

			48- 7-- 6--
			-3- 8-- -57
			2-- -9- -14

			-65 91- ---
			943 --8 -65
			7-2 --- --8
			"""
		)
	}

	static var allTests = [
		("test__singleNakedSingle__solvesThatProblem", test__singleNakedSingle__solvesThatProblem),
	]
}
