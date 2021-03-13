import XCTest
@testable import SudokuSolver

class NakedSingleTests: XCTestCase {
	let solve = nakedSingle(puzzle:)

	func test__singleValueMissing__addsMissingValue() throws {
		let puzzle = try Puzzle(dsl: """
			8-1 764 259
			695 281 374
			472 593 861

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)

		let solved = solve(puzzle)

		XCTAssertEqual(solved.description, """
		831 764 259
		695 281 374
		472 593 861

		153 829 647
		987 456 132
		246 137 598

		768 915 423
		514 372 986
		329 648 715
		"""
		)
	}

	func test__twoValuesMissing__addsOneMissingValue() throws {
		let puzzle = try Puzzle(dsl: """
			8-1 764 259
			695 281 374
			472 593 86-

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)

		let solved = solve(puzzle)

		XCTAssertEqual(solved.description, """
			831 764 259
			695 281 374
			472 593 86-

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)
	}

	func test__multipleItemsMissingInRow_singleItemMissingInColumn__addsInTheMissingColumn() throws {
		let puzzle = try Puzzle(dsl: """
		831 764 259
		695 281 374
		-72 5-3 861

		153 829 647
		987 456 132
		246 137 598

		768 915 423
		514 372 986
		329 648 715
		""")

		let solved = solve(puzzle)

		XCTAssertEqual(solved.description, """
		831 764 259
		695 281 374
		472 5-3 861

		153 829 647
		987 456 132
		246 137 598

		768 915 423
		514 372 986
		329 648 715
		""")
	}

	func test__multipleItemsMissingInRowAndColumn_singleItemMissingInGroup__addsInTheMissingGroup() throws {
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

		XCTAssertEqual(solved.description, """
		831 764 259
		695 281 374
		472 5-3 861

		153 829 647
		-87 4-6 132
		246 137 598

		768 915 423
		514 372 986
		329 648 715
		""")
	}

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

		let solved = solve(puzzle)
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
		("test__singleValueMissing__addsMissingValue", test__singleValueMissing__addsMissingValue),
		("test__twoValuesMissing__addsOneMissingValue", test__twoValuesMissing__addsOneMissingValue),
		("test__multipleItemsMissingInRow_singleItemMissingInColumn__addsInTheMissingColumn", test__multipleItemsMissingInRow_singleItemMissingInColumn__addsInTheMissingColumn),
		("test__multipleItemsMissingInRowAndColumn_singleItemMissingInGroup__addsInTheMissingGroup", test__multipleItemsMissingInRowAndColumn_singleItemMissingInGroup__addsInTheMissingGroup),
		("test__singleNakedSingle__solvesThatProblem", test__singleNakedSingle__solvesThatProblem),
	]
}
