import XCTest
@testable import SudokuSolver

class PuzzleTests: XCTestCase {
	let fullPuzzle = try! Puzzle(cells: [
		8,3,1, 7,6,4, 2,5,9,
		6,9,5, 2,8,1, 3,7,4,
		4,7,2, 5,9,3, 8,6,1,

		1,5,3, 8,2,9, 6,4,7,
		9,8,7, 4,5,6, 1,3,2,
		2,4,6, 1,3,7, 5,9,8,

		7,6,8, 9,1,5, 4,2,3,
		5,1,4, 3,7,2, 9,8,6,
		3,2,9, 6,4,8, 7,1,5,
	])

	func test__columns__fullPuzzle__returnsExpectedCells() throws {
		let columns = fullPuzzle.columns

		XCTAssertEqual(columns, [
			[ 8, 6, 4, 1, 9, 2, 7, 5, 3 ],
			[ 3, 9, 7, 5, 8, 4, 6, 1, 2 ],
			[ 1, 5, 2, 3, 7, 6, 8, 4, 9 ],
			[ 7, 2, 5, 8, 4, 1, 9, 3, 6 ],
			[ 6, 8, 9, 2, 5, 3, 1, 7, 4 ],
			[ 4, 1, 3, 9, 6, 7, 5, 2, 8 ],
			[ 2, 3, 8, 6, 1, 5, 4, 9, 7 ],
			[ 5, 7, 6, 4, 3, 9, 2, 8, 1 ],
			[ 9, 4, 1, 7, 2, 8, 3, 6, 5 ],
		])
	}

	func test__rows__fullPuzzle__returnsExpectedCells() throws {
		let rows = fullPuzzle.rows

		XCTAssertEqual(rows, [
			[ 8, 3, 1, 7, 6, 4, 2, 5, 9 ],
			[ 6, 9, 5, 2, 8, 1, 3, 7, 4 ],
			[ 4, 7, 2, 5, 9, 3, 8, 6, 1 ],
			[ 1, 5, 3, 8, 2, 9, 6, 4, 7 ],
			[ 9, 8, 7, 4, 5, 6, 1, 3, 2 ],
			[ 2, 4, 6, 1, 3, 7, 5, 9, 8 ],
			[ 7, 6, 8, 9, 1, 5, 4, 2, 3 ],
			[ 5, 1, 4, 3, 7, 2, 9, 8, 6 ],
			[ 3, 2, 9, 6, 4, 8, 7, 1, 5 ],
		])
	}

	func test__groups__fullPuzzle__returnsExpectedCells() throws {
		let groups = fullPuzzle.groups

		XCTAssertEqual(groups, [
			[
				8,3,1,
				6,9,5,
				4,7,2,
			], [
				7,6,4,
				2,8,1,
				5,9,3,
			], [
				2,5,9,
				3,7,4,
				8,6,1,
			],

			[
				1,5,3,
				9,8,7,
				2,4,6,
			], [
				8,2,9,
				4,5,6,
				1,3,7,
			], [
				6,4,7,
				1,3,2,
				5,9,8,
			],

			[
				7,6,8,
				5,1,4,
				3,2,9,
			], [
				9,1,5,
				3,7,2,
				6,4,8,
			], [
				4,2,3,
				9,8,6,
				7,1,5,
			]
		])
	}

	static let allTests = [
		("test__columns__fullPuzzle__returnsExpectedCells", test__columns__fullPuzzle__returnsExpectedCells),
		("test__rows__fullPuzzle__returnsExpectedCells", test__rows__fullPuzzle__returnsExpectedCells),
		("test__groups__fullPuzzle__returnsExpectedCells", test__groups__fullPuzzle__returnsExpectedCells),
	]
}
