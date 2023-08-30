import FzkExtensions
import XCTest
@testable import SudokuSolver

class PuzzleTests: XCTestCase {
	let solvedPuzzle = try! Puzzle(cellValues: [
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

	let unsolvedPuzzle = try! Puzzle(cellValues: [
		0,3,1, 7,6,4, 2,5,9,
		6,9,5, 2,8,1, 3,7,4,
		4,7,2, 5,9,3, 8,6,1,

		1,5,3, 8,2,9, 6,4,7,
		9,8,7, 4,5,6, 1,3,2,
		2,4,6, 1,3,7, 5,9,8,

		7,6,8, 9,1,5, 4,2,3,
		5,1,4, 3,7,2, 9,8,6,
		3,2,9, 6,4,8, 7,1,5,
	].map { $0 == 0 ? nil : $0 })

	func test__initWithCellValues__fullPuzzle__addsCorrectRowAndColumnAndGroupToCells() throws {
		let puzzle = try Puzzle(cellValues: [
			8,3,1, 7,6,4, 2,5,9, // 0-8
			6,9,5, 2,8,1, 3,7,4, // 9-17
			4,7,2, 5,9,3, 8,6,1, // 18-26

			1,5,3, 8,2,9, 6,4,7, // 27-35
			9,8,7, 4,5,6, 1,3,2, // 36-44
			2,4,6, 1,3,7, 5,9,8, // 45-53

			7,6,8, 9,1,5, 4,2,3, // 54-62
			5,1,4, 3,7,2, 9,8,6, // 63-71
			3,2,9, 6,4,8, 7,1,5, // 72-80
		])

		XCTAssertEqual(puzzle.cells[0], Cell(value: 8, row: 1, column: 1, group: 1), puzzle.cells[0].debugDescription)
		XCTAssertEqual(puzzle.cells[3], Cell(value: 7, row: 1, column: 4, group: 2), puzzle.cells[3].debugDescription)
		XCTAssertEqual(puzzle.cells[20], Cell(value: 2, row: 3, column: 3, group: 1), puzzle.cells[20].debugDescription)
		XCTAssertEqual(puzzle.cells[22], Cell(value: 9, row: 3, column: 5, group: 2), puzzle.cells[22].debugDescription)
		XCTAssertEqual(puzzle.cells[40], Cell(value: 5, row: 5, column: 5, group: 5), puzzle.cells[40].debugDescription)
		XCTAssertEqual(puzzle.cells[70], Cell(value: 8, row: 8, column: 8, group: 9), puzzle.cells[42].debugDescription)
	}

	func test__columns__fullPuzzle__returnsExpectedCells() throws {
		let columns = solvedPuzzle.columns.map { $0.map { $0.value } }

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
		let rows = solvedPuzzle.rows.map { $0.map { $0.value } }

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
		let groups = solvedPuzzle.groups.map { $0.map { $0.value } }

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

	func test__isSolved__puzzleIsSolved__returnsTrue() throws {
		XCTAssertTrue(solvedPuzzle.isSolved)
	}

	func test__isSolved__puzzleIsNotSolved__returnsFalse() throws {
		XCTAssertFalse(unsolvedPuzzle.isSolved)
	}

	func test__equals__puzzlesAreEqual__returnsTrue() throws {
		let cells = solvedPuzzle.cells
		let a = try Puzzle(cells: cells)
		let b = try Puzzle(cells: cells)

		XCTAssertEqual(a, b)
	}

	func test__equals__puzzlesAreNotEqual__returnsTrue() throws {
		var cells = solvedPuzzle.cells
		let a = try Puzzle(cells: cells)
		cells[0].value = nil
		let b = try Puzzle(cells: cells)

		XCTAssertNotEqual(a, b)
	}

	func test__initFromDSL__validFormsOfSolvedPuzzle__createsValidPuzzles() throws {
		let inputs: [(description: String, dsl: String)] = [
			("With whitespace", """
			831 764 259
			695 281 374
			472 593 861

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""),
			("Without whitespace", """
			831764259
			695281374
			472593861
			153829647
			987456132
			246137598
			768915423
			514372986
			329648715
			"""),
		]

		for test in inputs {
			do {
				let puzzle = try Puzzle(dsl: test.dsl)
				XCTAssertEqual(puzzle, solvedPuzzle, test.description)
			} catch {
				func t(_ error: Error) throws { throw error }
				XCTAssertNoThrow(try t(error), test.description)
			}
		}
	}

	func test__initFromDSL__commentIsIncluded__commentIsIgnored() async throws {
		let inputs: [(description: String, dsl: String)] = [
			("Comment before", """
			// Some comment
			-31 764 259
			695 281 374
			472 593 861

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""),
			("Comment in middle", """
			-31 764 259
			695 281 374
			472 593 861

			// Some comment

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""),
			("Multiple comments", """
			// Some comment
			-31 764 259
			695 281 374
			// Some comment
			472 593 861

			153 829 647
			987 456 132
			246 137 598
			// Some comment

			768 915 423
			514 372 986
			329 648 715

			// Some comment
			"""),
		]

		for test in inputs {
			var puzzle: Puzzle?
			XCTAssertNoThrow(puzzle = try Puzzle(dsl: test.dsl), test.description)
			if let puzzle {
				XCTAssertEqual(puzzle, unsolvedPuzzle, test.description)
			}
		}
	}

	func test__initFromDSL__validFormsOfUnsolvedPuzzle__createsValidPuzzles() throws {
		let inputs: [(description: String, dsl: String)] = [
			("With whitespace", """
			-31 764 259
			695 281 374
			472 593 861

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""),
			("Without whitespace", """
			-31764259
			695281374
			472593861
			153829647
			987456132
			246137598
			768915423
			514372986
			329648715
			"""),
		]

		for test in inputs {
			do {
				let puzzle = try Puzzle(dsl: test.dsl)
				XCTAssertEqual(puzzle, unsolvedPuzzle, test.description)
			} catch {
				func t(_ error: Error) throws { throw error }
				XCTAssertNoThrow(try t(error), test.description)
			}
		}
	}

	func test__initFromDSL__cellMissingInRow__throws() throws {
		let dsl = """
			831 764 259
			695 281 374
			472 593 861

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 71
			"""
		XCTAssertThrowsError(try Puzzle(dsl: dsl)) { (error) in
			switch error as? DSLParseError {
			case let .invalidCellCount(rowIndex: index):
				XCTAssertEqual(index, 8)
			default:
				XCTFail()
			}
		}
	}

	func test__initFromDSL__rowMissing__throws() throws {
		let dsl = """
			831 764 259
			695 281 374
			472 593 861

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			"""
		XCTAssertThrowsError(try Puzzle(dsl: dsl)) { (error) in
			switch error as? DSLParseError {
			case .invalidRowCount:
				break
			default:
				XCTFail()
			}
		}
	}

	func test__description__puzzleWithEmptyValues__returnsValidValue() throws {
		let expected = """
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
		let actual = unsolvedPuzzle.description

		XCTAssertEqual(actual, expected)
	}

	func test__candidatesForCell__cellHasValue__returnsNoCandidates() throws {
		let cell = unsolvedPuzzle.cells.first { $0.hasValue }!

		let candidates = unsolvedPuzzle.candidates(for: cell)

		XCTAssertEqual(candidates, [])
	}

	func test__candidatesForCell__cellHasNoValue_onlyCellWithoutValue__returnsMissingNumber() throws {
		let puzzle = Puzzle("""
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
		)!

		let cell = puzzle.cells[0]
		let candidates = puzzle.candidates(for: cell)

		XCTAssertEqual(candidates, [8])
	}

	func test__candidatesForCell__cellHasNoValue_multipleMissingInGroup_oneMissingInRow_oneMissingInColumn__returnsMissingNumber() throws {
		let puzzle = try Puzzle(dsl: """
			-31 764 259
			695 281 374
			47- 593 861

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)

		let cell = puzzle.cells[0]
		let candidates = puzzle.candidates(for: cell)

		XCTAssertEqual(candidates, [8])
	}

	func test__candidatesForCell__cellHasNoValue_multipleMissingInGroup_multipleMissingInRow_oneMissingInColumn__returnsMissingNumber() throws {
		let puzzle = try Puzzle(dsl: """
			-31 764 -59
			695 281 374
			47- 593 861

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)

		let cell = puzzle.cells[0]
		let candidates = puzzle.candidates(for: cell)

		XCTAssertEqual(candidates, [8])
	}

	func test__candidatesForCell__cellHasNoValue_multipleMissingInGroup_oneMissingInRow_multipleMissingInColumn__returnsMissingNumber() throws {
		let puzzle = try Puzzle(dsl: """
			-31 764 259
			695 281 374
			47- 593 861

			153 829 647
			987 456 132
			-46 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)

		let cell = puzzle.cells[0]
		let candidates = puzzle.candidates(for: cell)

		XCTAssertEqual(candidates, [8])
	}

	func test__candidatesForCell__cellHasNoValue_oneMissingInGroup_multipleMissingInRow_multipleMissingInColumn__returnsMissingNumber() throws {
		let puzzle = try Puzzle(dsl: """
			-31 764 -59
			695 281 374
			472 593 861

			153 829 647
			987 456 132
			-46 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)

		let cell = puzzle.cells[0]
		let candidates = puzzle.candidates(for: cell)

		XCTAssertEqual(candidates, [8])
	}

	func test__candidatesForCell__cellHasNoValue_sameOtherNumberMissingInGroupAndRowAndColumn__returnsAllMissingNumbers() throws {
		let puzzle = try Puzzle(dsl: """
			-31 764 -59
			695 281 374
			47- 593 861

			153 829 647
			987 456 132
			-46 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)

		let cell = puzzle.cells[0]
		let candidates = puzzle.candidates(for: cell)

		XCTAssertEqual(candidates, [2, 8])
	}

	func test__candidatesForCell__cellHasNoValue_sameOtherNumberMissingInGroupAndRow_differentNumberMissingInColumn__returnsSingleMissingNumber() throws {
		let puzzle = try Puzzle(dsl: """
			-31 764 -59
			695 281 374
			47- 593 861

			153 829 647
			-87 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)

		let cell = puzzle.cells[0]
		let candidates = puzzle.candidates(for: cell)

		XCTAssertEqual(candidates, [8])
	}

	func test__cellsPointingAt__twoCellsGiven_groupIsShared_rowIsNotShared_colIsNotShared__returnsOtherCellsInGroup() async throws {
		let puzzle = Puzzle()

		let cells = try puzzle.cells.filter(at: [
			.init(row: 1, column: 1),
			.init(row: 2, column: 2),
		])

		let actual = puzzle.cells(pointingAt: cells)

		XCTAssertEqual(actual.count, 7)
		XCTAssertEqual(actual.map(\.group) |> Set.init, [1])
	}

	func test__cellsPointingAt__twoCellsGiven_groupIsShared_rowIsShared_colIsNotShared__returnsOtherCellsInGroupAndRow() async throws {
		let puzzle = Puzzle()

		let cells = try puzzle.cells.filter(at: [
			.init(row: 1, column: 1),
			.init(row: 1, column: 2),
		])

		let actual = puzzle.cells(pointingAt: cells)

		XCTAssertEqual(actual.count, 13)
		XCTAssertTrue(actual.allSatisfy({
			$0.group == 1 || $0.row == 1
		}))
	}

	func test__cellsPointingAt__twoCellsGiven_groupIsNotShared_rowIsNotShared_colIsNotShared__returnsPointingCells() async throws {
		let puzzle = Puzzle()

		let cells = try puzzle.cells.filter(at: [
			.init(row: 1, column: 1),
			.init(row: 4, column: 5),
		])

		let actual = puzzle.cells(pointingAt: cells)

		XCTAssertEqual(actual, try puzzle.cells.filter(at: [
			.init(row: 1, column: 5),
			.init(row: 4, column: 1),
		]))
	}

	func test__cellsPointingAt__twoCellsGiven_groupIsNotShared_rowIsNotShared_colIsNotShared_groupsShareColumn__returnsPointingCells() async throws {
		let puzzle = Puzzle()

		let cells = try puzzle.cells.filter(at: [
			.init(row: 1, column: 1),
			.init(row: 4, column: 3),
		])

		let actual = puzzle.cells(pointingAt: cells)

		XCTAssertEqual(actual, try puzzle.cells.filter(at: [
			.init(row: 1, column: 3),
			.init(row: 2, column: 3),
			.init(row: 3, column: 3),
			.init(row: 4, column: 1),
			.init(row: 5, column: 1),
			.init(row: 6, column: 1),
		]))
	}

	func test__pencilMarkKnownValues__singleValueMissing__updatesPencilMark() throws {
		var puzzle = try Puzzle(dsl: """
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

		let coordinate = try Coordinate(row: 1, column: 2)

		for cell in puzzle.cells.filter(notAt: coordinate) {
			XCTAssertEqual(cell.pencilMarks, [], cell.debugDescription)
		}

		XCTAssertEqual(puzzle.cells.cell(at: coordinate).pencilMarks, [1,2,3,4,5,6,7,8,9])

		puzzle.pencilMarkKnownValues()

		for cell in puzzle.cells.filter(notAt: coordinate) {
			XCTAssertEqual(cell.pencilMarks, [], cell.debugDescription)
		}

		XCTAssertEqual(puzzle.cells.cell(at: coordinate).pencilMarks, [3])
	}

	func test__pencilMarkKnownValues__twoValuesMissing__updatesPencilMarks() throws {
		var puzzle = try Puzzle(dsl: """
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

		let coordinates = try [
			Coordinate(row: 1, column: 2),
			.init(row: 3, column: 9),
		]

		for cell in puzzle.cells.filter(notAt: coordinates) {
			XCTAssertEqual(cell.pencilMarks, [], cell.debugDescription)
		}

		for cell in puzzle.cells.filter(at: coordinates) {
			XCTAssertEqual(cell.pencilMarks, [1,2,3,4,5,6,7,8,9])
		}

		puzzle.pencilMarkKnownValues()

		for cell in puzzle.cells.filter(notAt: coordinates) {
			XCTAssertEqual(cell.pencilMarks, [], cell.debugDescription)
		}

		XCTAssertEqual(puzzle.cells.cell(at: coordinates[0]).pencilMarks, [3])
		XCTAssertEqual(puzzle.cells.cell(at: coordinates[1]).pencilMarks, [1])
	}

	func test__pencilMarkKnownValues__multipleItemsMissingInRow_singleItemMissingInColumn__updatesPencilMarks() throws {
		var puzzle = try Puzzle(dsl: """
			831 764 259
			695 281 374
			-72 5-3 861

			153 829 647
			987 456 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)
		let coordinates = try [
			Coordinate(row: 3, column: 1),
			.init(row: 3, column: 5),
		]

		for cell in puzzle.cells.filter(notAt: coordinates) {
			XCTAssertEqual(cell.pencilMarks, [], cell.debugDescription)
		}

		for cell in puzzle.cells.filter(at: coordinates) {
			XCTAssertEqual(cell.pencilMarks, [1,2,3,4,5,6,7,8,9])
		}

		puzzle.pencilMarkKnownValues()

		for cell in puzzle.cells.filter(notAt: coordinates) {
			XCTAssertEqual(cell.pencilMarks, [], cell.debugDescription)
		}

		XCTAssertEqual(puzzle.cells.cell(at: coordinates[0]).pencilMarks, [4])
		XCTAssertEqual(puzzle.cells.cell(at: coordinates[1]).pencilMarks, [9])
	}

	func test__pencilMarkKnownValues__multipleItemsMissingInRowAndColumn_singleItemMissingInGroup__updatesPencilMarks() throws {
		var puzzle = try Puzzle(dsl: """
			831 764 259
			695 281 374
			-72 5-3 861

			153 829 647
			-87 4-6 132
			246 137 598

			768 915 423
			514 372 986
			329 648 715
			"""
		)
		let coordinates = try [
			Coordinate(row: 3, column: 1),
			.init(row: 3, column: 5),
			.init(row: 5, column: 1),
			.init(row: 5, column: 5),
		]

		for cell in puzzle.cells.filter(notAt: coordinates) {
			XCTAssertEqual(cell.pencilMarks, [], cell.debugDescription)
		}

		for cell in puzzle.cells.filter(at: coordinates) {
			XCTAssertEqual(cell.pencilMarks, [1,2,3,4,5,6,7,8,9])
		}

		puzzle.pencilMarkKnownValues()

		for cell in puzzle.cells.filter(notAt: coordinates) {
			XCTAssertEqual(cell.pencilMarks, [], cell.debugDescription)
		}

		XCTAssertEqual(puzzle.cells.cell(at: coordinates[0]).pencilMarks, [4])
		XCTAssertEqual(puzzle.cells.cell(at: coordinates[1]).pencilMarks, [9])
		XCTAssertEqual(puzzle.cells.cell(at: coordinates[2]).pencilMarks, [9])
		XCTAssertEqual(puzzle.cells.cell(at: coordinates[3]).pencilMarks, [5])
	}
}
