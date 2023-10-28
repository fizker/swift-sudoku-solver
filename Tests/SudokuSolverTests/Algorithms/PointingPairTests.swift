import FzkExtensions
import XCTest
@testable import SudokuSolver

final class PointingPairTests: XCTestCase {
	let algo = PointingPair()

	/// A puzzle containing several pointing pairs.
	///
	/// There are multiple candidates for pointing pairs. Note that there are more than this:
	/// 1. 2 in row 1 columns 7 and 8 pointing at nothing
	/// 2. 8 in row 2 columns 5 and 6 pointing at R2C7
	/// 3. 8 in row 3 columns 2 and 3 pointing at nothing
	/// 4. 8 in row 5 columns 2 and 3 pointing at R5C7+8
	/// 5. 8 in row 9 columns 5 and 6 pointing at R9C7+9
	///
	/// The following also form x-wings: 2+5 and 3+4.
	var puzzle: Puzzle!

	override func setUp() async throws {
		puzzle = try Puzzle(dsl: """
			-91 354 ---
			234 --- 591
			--- 219 -34

			5-- 89- ---
			1-- 52- --9
			329 -46 --5

			91- -35 --2
			8-- --- -5-
			4-- --- -1-
			"""
		)
		puzzle.pencilMarkKnownValues()
	}

	func test__multiplePointingPairsPresent_algoRunOnce__firstPointingPairIsResolved() async throws {
		let pointingPair = try [
			Coordinate(row: 6, column: 7),
			Coordinate(row: 6, column: 8),
		]
		let pointingAt = try [
			Coordinate(row: 5, column: 7),
			Coordinate(row: 5, column: 8),
		]

		for cell in puzzle.cells.filter(at: pointingPair) {
			XCTAssertTrue(cell.pencilMarks.contains(8), "Asserting that we have the expected cells")
		}

		XCTAssertEqual(puzzle.cells.cell(at: pointingAt[0]).pencilMarks, [3,4,6,7,8])
		XCTAssertEqual(puzzle.cells.cell(at: pointingAt[1]).pencilMarks, [4,6,7,8])

		let solved = try running(algo, on: puzzle)

		XCTAssertEqual(solved.cells.cell(at: pointingAt[0]).pencilMarks, [3,4,6,7])
		XCTAssertEqual(solved.cells.cell(at: pointingAt[1]).pencilMarks, [4,6,7])

		for cell in solved.cells.filter(at: pointingPair) {
			XCTAssertTrue(cell.pencilMarks.contains(8), "These should be unmodified")
		}
	}

	func test__multiplePointingPairsPresent_firstPairManuallyResolved_secondPairHasNoEffect__thirdPointingPairIsResolved() async throws {
		let pointingPair = try [
			Coordinate(row: 7, column: 7),
			Coordinate(row: 7, column: 8),
		]
		let firstPointingAt = try [
			Coordinate(row: 5, column: 7),
			Coordinate(row: 5, column: 8),
		]
		let secondPointingAt = try [
			Coordinate(row: 9, column: 7),
			Coordinate(row: 9, column: 9),
		]

		for cell in puzzle.cells.filter(at: pointingPair) {
			XCTAssertTrue(cell.pencilMarks.contains(8), "Asserting that we have the expected cells")
		}

		for cell in puzzle.cells.filter(at: secondPointingAt) {
			XCTAssertTrue(cell.pencilMarks.contains(8))
		}

		for var cell in puzzle.cells.filter(at: firstPointingAt) {
			cell.pencilMarks.remove(8)
			puzzle.update(cell)
		}

		let solved = try running(algo, on: puzzle)

		for cell in solved.cells.filter(at: pointingPair) {
			XCTAssertTrue(cell.pencilMarks.contains(8), "These should be unmodified")
		}

		for cell in solved.cells.filter(at: secondPointingAt) {
			XCTAssertFalse(cell.pencilMarks.contains(8), cell.debugDescription)
		}
	}

	func test__pointingPairPresent_pointingPairIsNotAdjacent__pencilMarksAreUpdated() async throws {
		// There is a pointing pair at row 3 columns 7 and 9.
		let puzzle = try Puzzle(dsl: """
			-3- --- 674
			5-6 7-- -9-
			79- 36- -8-

			2-7 6-- -5-
			9-- --7 8-2
			-5- --2 --7

			--- 478 -3-
			-7- --- 148
			4-- --- 72-
			"""
		) ~ {
			$0.pencilMarkKnownValues()
			// There are other pointing pairs that are not problematic that are hit first. We eliminate them manually first
			for update in [
				(8,3,[3,5,9]),
				(4,9,[3,9]),
			] as [(row: Int, column: Int, pencilMarks: Set<Int>)] {
				var cell = $0.cells.cell(at: try Coordinate(row: update.row, column: update.column))
				cell.pencilMarks = update.pencilMarks
				$0.update(cell)
			}
		}

		let pointedAt = try Coordinate(row: 3, column: 6)

		XCTAssertEqual(puzzle.cells.cell(at: pointedAt).pencilMarks, [ 1, 4, 5 ])

		let solved = try running(algo, on: puzzle)

		XCTAssertEqual(solved.cells.cell(at: pointedAt).pencilMarks, [ 1, 4 ])
	}
}
