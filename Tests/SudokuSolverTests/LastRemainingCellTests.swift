import XCTest
@testable import SudokuSolver

class LastRemainingCellTests: XCTestCase {
	func test__lastRemainingCell__singleValueMissing__addsMissingValue() throws {
		let puzzle = try Puzzle(dsl: """
			-31 764 259
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

		let solved = lastRemainingCell(puzzle: puzzle)

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

	func test__lastRemainingCell__twoValuesMissing__addsOneMissingValue() throws {
		let puzzle = try Puzzle(dsl: """
			-31 764 259
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

		let solved = lastRemainingCell(puzzle: puzzle)

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

	static let allTests = [
		("test__lastRemainingCell__singleValueMissing__addsMissingValue", test__lastRemainingCell__singleValueMissing__addsMissingValue),
		("test__lastRemainingCell__twoValuesMissing__addsOneMissingValue", test__lastRemainingCell__twoValuesMissing__addsOneMissingValue),
	]
}
