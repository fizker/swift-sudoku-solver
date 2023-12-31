import XCTest
@testable import SudokuSolver

class HiddenSingleTests: XCTestCase {
	let algo = HiddenSingle()

	func test__singleNakedSingle__fillsInMissingNumber() throws {
		var puzzle = try Puzzle(dsl: """
			831 764 259
			695 281 374
			472 593 861

			153 829 647
			987 4-6 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)
		puzzle.pencilMarkKnownValues()

		let solved = try running(algo, on: puzzle)
		XCTAssertIsSolved(solved)
	}

	func test__containsOneHiddenSingles__fillsInHiddenSingle() async throws {
		var puzzle = try Puzzle(dsl: """
			-5- 6-- 3--
			--9 --- ---
			--- -1- --9

			7-- 4-- 19-
			--- 8-- ---
			3-6 --1 -47

			9-- --- -3-
			-38 -96 --4
			1-4 38- -7-
			"""
		)
		puzzle.pencilMarkKnownValues()

		let solved = try running(algo, on: puzzle)
		XCTAssertEqual(solved.description, """
			-5- 6-9 3--
			--9 --- ---
			--- -1- --9

			7-- 4-- 19-
			--- 8-- ---
			3-6 --1 -47

			9-- --- -3-
			-38 -96 --4
			1-4 38- -7-
			"""
		)
	}

	func test__containsMultipleHiddenSingles__addsFirstHiddenSingle() async throws {
		var puzzle = try Puzzle(dsl: """
			-5- 6-- 3--
			--9 --- ---
			--- -1- --9

			7-- 4-- 19-
			--- 8-- ---
			3-6 --1 -47

			9-- --- -3-
			--8 -96 --4
			1-4 38- -7-
			"""
		)
		puzzle.pencilMarkKnownValues()

		let solved = try running(algo, on: puzzle)
		XCTAssertEqual(solved.description, """
			-5- 6-9 3--
			--9 --- ---
			--- -1- --9

			7-- 4-- 19-
			--- 8-- ---
			3-6 --1 -47

			9-- --- -3-
			--8 -96 --4
			1-4 38- -7-
			"""
		)
	}
}
