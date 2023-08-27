import XCTest
@testable import SudokuSolver

final class ArrayCellTests: XCTestCase {
	let cells = [
		Cell(row: 1, column: 1, group: 1),
		Cell(row: 1, column: 2, group: 1),
		Cell(row: 1, column: 3, group: 1),

		Cell(row: 1, column: 4, group: 2),
		Cell(row: 1, column: 5, group: 2),
		Cell(row: 1, column: 6, group: 2),

		Cell(row: 1, column: 7, group: 2),
		Cell(row: 1, column: 8, group: 2),
		Cell(row: 1, column: 9, group: 2),
	]

	func test__cellAt__firstCellMatches__returnsCell() async throws {
		let expected = cells[0]
		let actual = cells.cell(at: try .init(row: 1, column: 1))

		XCTAssertEqual(actual, expected)
	}

	func test__cellAt__fourthCellMatches__returnsCell() async throws {
		let expected = cells[3]
		let actual = cells.cell(at: try .init(row: 1, column: 4))

		XCTAssertEqual(actual, expected)
	}

	func test__filterAt__singleCoordinateGiven__singleCellReturned() async throws {
		let expected = [ cells[2] ]
		let actual = cells.filter(at: try .init(row: 1, column: 3))

		XCTAssertEqual(actual, expected)
	}

	func test__filterAt__multipleCoordinatesGiven__singleCellReturned() async throws {
		let expected = [ cells[2], cells[5] ]
		let actual = cells.filter(at: try .init(row: 1, column: 3), try .init(row: 1, column: 6))

		XCTAssertEqual(actual, expected)
	}

	func test__filterNotAt__singleCoordinateGiven__otherCellsReturned() async throws {
		var expected = cells
		expected.remove(at: 2)

		let actual = cells.filter(notAt: try .init(row: 1, column: 3))

		XCTAssertEqual(actual, expected)
	}

	func test__filterNotAt__multipleCoordinatesGiven__otherCellsReturned() async throws {
		var expected = cells
		expected.remove(at: 5)
		expected.remove(at: 2)

		let actual = cells.filter(notAt: try .init(row: 1, column: 3), try .init(row: 1, column: 6))

		XCTAssertEqual(actual, expected)
	}
}
