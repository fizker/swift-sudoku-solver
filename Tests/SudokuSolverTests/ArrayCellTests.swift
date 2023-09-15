import XCTest
@testable import SudokuSolver

final class ArrayCellTests: XCTestCase {
	let cells = [
		Cell(row: 1, column: 1, box: 1),
		Cell(row: 1, column: 2, box: 1),
		Cell(row: 1, column: 3, box: 1),

		Cell(row: 1, column: 4, box: 2),
		Cell(row: 1, column: 5, box: 2),
		Cell(row: 1, column: 6, box: 2),

		Cell(row: 1, column: 7, box: 2),
		Cell(row: 1, column: 8, box: 2),
		Cell(row: 1, column: 9, box: 2),
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
