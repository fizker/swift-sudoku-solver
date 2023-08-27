import Foundation

public struct Puzzle: Equatable {
	/// Cells for a standard 9x9 puzzle match the array like so:
	/// ```
	/// [
	///    0,  1,  2,  3,  4,  5,  6,  7,  8,
	///    9, 10, 11, 12, 13, 14, 15, 16, 17,
	///   18, 19, 20, 21, 22, 23, 24, 25, 26,
	///   27, 28, 29, 30, ...
	/// ```
	///
	/// Any unfilled cell is represented by nil
	private(set) var cells: [Cell]

	init(cells: [Cell]) throws {
		self.cells = cells
	}

	mutating func pencilMarkKnownValues() {
		for var cell in cells {
			guard !cell.hasValue
			else { continue }

			let candidates = candidates(for: cell)

			for pencilMark in cell.pencilMarks where !candidates.contains(pencilMark) {
				cell.pencilMarks.remove(pencilMark)
				update(cell)
			}
		}
	}

	/// Default constructor. Throws if the given cells are not in a legal constellation
	public init(cellValues: [Int?]) throws {
		var row = 1
		var column = 0
		var rg = 0
		try self.init(cells: cellValues.map {
			if column == 9 {
				column = 0
				row += 1
				// The `x / 3 * 3` does a thing, because we are in Int-land;
				// the calculation is not lossless
				rg = (row-1) / 3 * 3
			}
			column += 1

			let groupIndex = rg + (column-1) / 3

			return Cell(value: $0, row: row, column: column, group: groupIndex + 1)
		})
	}

	func updating(_ cell: Cell) -> Puzzle {
		var copy = self
		copy.update(cell)
		return copy
	}

	mutating func update(_ cell: Cell) {
		let rowIndex = cell.row - 1
		let columnIndex = cell.column - 1
		let index = rowIndex * 9 + columnIndex
		cells[index] = cell
	}

	public var isSolved: Bool { cells.allSatisfy { $0.hasValue } }

	/// Returns the possible digits that the cell can contain, after removing digits that are present in the contain row, column and group.
	func candidates(for cell: Cell) -> [Int] {
		guard !cell.hasValue
		else { return [] }

		var candidates = [1,2,3,4,5,6,7,8,9]

		for c in cells {
			guard !candidates.isEmpty
			else { return [] }

			guard c.row == cell.row || c.column == cell.column || c.group == cell.group
			else { continue }

			guard let v = c.value
			else { continue }

			candidates.removeAll { $0 == v }
		}

		return candidates
	}

	/// Returns the three containers that this cell is a part of.
	func containers(for cell: Cell) -> [any Container] {
		return [
			rows[cell.row - 1],
			columns[cell.column - 1],
			groups[cell.group - 1],
		]
	}

	/// The cells as represented by columns
	var columns: [Column] {
		var columns = [[Cell]](repeating: [Cell](repeating: Cell(value: 0, row: 0, column: 0, group: 0), count: 9), count: 9)

		for column in 0..<9 {
			for row in 0..<9 {
				columns[column][row] = cells[column + 9 * row]
			}
		}

		return columns.map { Column(cells: $0, position: $0[0].column) }
	}

	var rows: [Row] {
		var rows = [[Cell]](repeating: [Cell](repeating: Cell(value: 0, row: 0, column: 0, group: 0), count: 9), count: 9)

		for row in 0..<9 {
			for column in 0..<9 {
				rows[row][column] = cells[column + 9 * row]
			}
		}

		return rows.map { Row(cells: $0, position: $0[0].row) }
	}

	var groups: [Group] {
		var groups = [[Cell]](repeating: [Cell](repeating: Cell(value: 0, row: 0, column: 0, group: 0), count: 9), count: 9)

		for row in 0..<9 {
			let rg = row / 3
			let itemMod = (row % 3) * 3
			for column in 0..<9 {
				let cg = column / 3
				let group = rg * 3 + cg
				let item: Int

				switch column {
					case ...2:
						item = itemMod + column
					case 3...5:
						item = itemMod + column - 3
					case 6...:
						item = itemMod + column - 6
					default:
						fatalError("This should never be reached")
						break
				}

				groups[group][item] = cells[column + 9 * row]
			}
		}

		return groups.map { Group(cells: $0, position: $0[0].group) }
	}
}

extension Puzzle: CustomStringConvertible {
	public var description: String {
		func add(_ separator: String, to array: [String]) -> [String] {
			let first = Array(array[0..<3])
			let second = Array(array[3..<6])
			let third = Array(array[6...])
			return first + [separator] + second + [separator] + third
		}

		let r = rows.map { add(" ", to: $0.map { $0.description }).joined() }

		return add("", to: r).joined(separator: "\n")
	}
}

public enum DSLParseError : Error {
	case invalidRowCount
	case invalidCellCount(rowIndex:Int)
}

extension Puzzle: LosslessStringConvertible {
	public init(dsl: String) throws {
		let rows = dsl
			.components(separatedBy: .newlines)
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.map { String($0.filter { " " != $0 }) }
			.filter { !$0.isEmpty }

		guard rows.count == 9
		else { throw DSLParseError.invalidRowCount }

		var rowIndex = 0
		for row in rows {
			guard row.count == 9
			else { throw DSLParseError.invalidCellCount(rowIndex: rowIndex) }
			rowIndex += 1
		}

		let cells = rows.flatMap { $0.map { Int("\($0)") } }

		try self.init(cellValues: cells)
	}

	public init?(_ description: String) {
		do {
			try self.init(dsl: description)
		} catch {
			return nil
		}
	}
}
