import Foundation

extension Bool {
	var toggled: Bool { !self }
}

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
	private(set) public var cells: [Cell]

	/// Creates a new Puzzle with the given cells.
	///
	/// - parameter cells: The cells of the puzzle.
	public init(cells: [Cell]) throws {
		self.cells = cells
	}

	public init() {
		try! self.init(cellValues: .init(repeating: nil, count: 81))
	}

	/// Default constructor. Throws if the given cells are not in a legal constellation
	///
	/// - parameter cellValues: The values of the cells, or `nil` if the cell should be empty. The cells are filled starting at row 1 column 1, filling out the rows first and then the columns.
	public init(cellValues: [Int?]) throws {
		var row = 1
		var column = 0
		try self.init(cells: cellValues.map {
			if column == 9 {
				column = 0
				row += 1
			}
			column += 1

			return try Cell(value: $0, coordinate: .init(row: row, column: column))
		})
	}

	/// Resets the pencil marks of all cells to only what can be derived from the current values of the cells.
	public mutating func pencilMarkKnownValues() {
		self = ResetPencilMarks.reset(self)
	}

	/// Returns a copy of the puzzle where pencil marks of all cells are reset to only what can be derived from the current values of the cells.
	public func resettingPencilMarks() -> Puzzle {
		return ResetPencilMarks.reset(self)
	}

	/// Returns a copy of the puzzle updated with the given cell.
	///
	/// If the cell have a value, the pencil marks of any cell that it points at will be updated acoordingly.
	///
	/// - parameter cell: The cell to update.
	/// - returns: A copy of the puzzle with the updated cell.
	func updating(_ cell: Cell) -> Puzzle {
		var copy = self
		copy.update(cell)
		return copy
	}

	/// Updates the puzzle with the given cell.
	///
	/// If the cell have a value, the pencil marks of any cell that it points at will be updated acoordingly.
	///
	/// - parameter cell: The cell to update.
	mutating func update(_ cell: Cell) {
		let rowIndex = cell.row - 1
		let columnIndex = cell.column - 1
		let index = rowIndex * 9 + columnIndex

		let isValueUpdated = cells[index].value != cell.value
		cells[index] = cell

		if isValueUpdated, let value = cell.value {
			// Recalculate the affected pencil marks
			for container in containers(for: cell) {
				for var otherCell in container.cells {
					otherCell.pencilMarks.remove(value)
					update(otherCell)
				}
			}
		}
	}

	/// Checks if the puzzle is currently solved. It is considered solved if all cells have a value.
	public var isSolved: Bool { cells.allSatisfy(\.hasValue) }

	/// Returns the possible digits that the cell can contain, after removing digits that are present in the contain row, column and box.
	func candidates(for cell: Cell) -> [Int] {
		guard !cell.hasValue
		else { return [] }

		var candidates = [1,2,3,4,5,6,7,8,9]

		for c in cells {
			guard !candidates.isEmpty
			else { return [] }

			guard c.row == cell.row || c.column == cell.column || c.box == cell.box
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
			boxes[cell.box - 1],
		]
	}

	/// Returns all cells that are pointing at the given cells.
	///
	/// `O(n*2m)` where `n` is `puzzle.cells.count` and `m` is the number of cells passed in.
	func cells(pointingAt cells: [Cell]) -> [Cell] {
		self.cells.filter { cell in
			guard !cells.contains(cell)
			else { return false }

			return cells.allSatisfy {
				cell.row == $0.row ||
				cell.column == $0.column ||
				cell.box == $0.box
			}
		}
	}

	/// The columns of the puzzle.
	public var columns: [Column] {
		var columns = [[Cell]](repeating: [Cell](repeating: Cell(value: 0, row: 0, column: 0, box: 0), count: 9), count: 9)

		for column in 0..<9 {
			for row in 0..<9 {
				columns[column][row] = cells[column + 9 * row]
			}
		}

		return columns.map { Column(cells: $0, position: $0[0].column) }
	}

	/// The rows of the puzzle.
	public var rows: [Row] {
		var rows = [[Cell]](repeating: [Cell](repeating: Cell(value: 0, row: 0, column: 0, box: 0), count: 9), count: 9)

		for row in 0..<9 {
			for column in 0..<9 {
				rows[row][column] = cells[column + 9 * row]
			}
		}

		return rows.map { Row(cells: $0, position: $0[0].row) }
	}

	/// The boxes of the puzzle.
	public var boxes: [Box] {
		var boxes = [[Cell]](repeating: [Cell](repeating: Cell(value: 0, row: 0, column: 0, box: 0), count: 9), count: 9)

		for row in 0..<9 {
			let rg = row / 3
			let itemMod = (row % 3) * 3
			for column in 0..<9 {
				let cg = column / 3
				let box = rg * 3 + cg
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

				boxes[box][item] = cells[column + 9 * row]
			}
		}

		return boxes.map { Box(cells: $0, position: $0[0].box) }
	}

	/// All containers of the puzzle, starting with rows, then columns and lastly boxes.
	var containers: [any Container] {
		let r = rows.map { $0 as (any Container) }
		let c = columns.map { $0 as (any Container) }
		let g = boxes.map { $0 as (any Container) }

		return r + c + g
	}
}

extension Puzzle: CustomStringConvertible, CustomDebugStringConvertible {
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

	public var debugDescription: String {
		let cells = rows
			.map { $0.cells.filter(\.hasValue.toggled).map(\.debugDescription).joined(separator: ", ") }
			.filter(\.isEmpty.toggled)

		return """
		\(description)

		\(cells.isEmpty ? "" : "Empty cells:")
		\(cells.joined(separator: "\n"))
		"""
		.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}

public enum DSLParseError : Error {
	case invalidRowCount
	case invalidCellCount(rowIndex:Int)
}

extension Puzzle: LosslessStringConvertible {
	public init(dsl: String, pencilMarked: Bool = false) throws {
		let rows = dsl
			.components(separatedBy: .newlines)
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.map { String($0.filter { " " != $0 }) }
			.filter { !$0.isEmpty && !$0.starts(with: "//") }

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

		if pencilMarked {
			pencilMarkKnownValues()
		}
	}

	public init?(_ description: String) {
		do {
			try self.init(dsl: description)
		} catch {
			return nil
		}
	}
}
