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
	var cells: [Int?]

	/// Default constructor. Throws if the given cells are not in a legal constellation
	public init(cells: [Int?]) throws {
		self.cells = cells
	}

	mutating func updateCell(value: Int?, row: Int, column: Int) throws {
		try updateCell(value: value, rowIndex: row - 1, columnIndex: column - 1)
	}

	mutating func updateCell(value: Int?, rowIndex: Int, columnIndex: Int) throws {
		cells[rowIndex * 9 + columnIndex] = value
	}

	public var isSolved: Bool { !cells.contains(nil) }

	/// The cells as represented by columns
	var columns: [[Int?]] {
		var columns = [[Int?]](repeating: [Int?](repeating: nil, count: 9), count: 9)

		for column in 0..<9 {
			for row in 0..<9 {
				columns[column][row] = cells[column + 9 * row]
			}
		}

		return columns
	}

	var rows: [[Int?]] {
		var rows = [[Int?]](repeating: [Int?](repeating: nil, count: 9), count: 9)

		for row in 0..<9 {
			for column in 0..<9 {
				rows[row][column] = cells[column + 9 * row]
			}
		}

		return rows
	}

	var groups: [[Int?]] {
		var groups = [[Int?]](repeating: [Int?](repeating: nil, count: 9), count: 9)

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

		return groups
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

		let r = rows.map { add(" ", to: $0.map { $0?.description ?? "-" }).joined() }

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

		try self.init(cells: cells)
	}

	public init?(_ description: String) {
		do {
			try self.init(dsl: description)
		} catch {
			return nil
		}
	}
}
