public struct Coordinate: Equatable {
	public var row: Int
	public var column: Int
	public var box: Int

	public enum Error: Swift.Error {
		case invalidRow, invalidColumn, invalidBox
	}

	public init(row: Int, column: Int, box: Int) throws {
		guard 1 <= row && row <= 9
		else { throw Error.invalidRow }
		guard 1 <= column && column <= 9
		else { throw Error.invalidColumn }
		guard 1 <= box && box <= 9
		else { throw Error.invalidBox }

		self.row = row
		self.column = column
		self.box = box
	}

	public init(row: Int, column: Int) throws {
		// This is now 0 for 1-3, 3 for 4-6, 6 for 7-9
		let rb = (row-1) / 3 * 3

		// This is now 0 for 1-3, 1 for 4-6, 2 for 7-9
		let cb = (column-1) / 3

		let box = cb + 1 + rb

		try self.init(row: row, column: column, box: box)
	}
}

extension Array where Element == Coordinate {
	init(rows: [Int], columns: [Int]) throws {
		self = try rows.flatMap { row in
			try columns.map { try Coordinate(row: row, column: $0) }
		}
	}
}

public struct Cell: Equatable, CustomStringConvertible, CustomDebugStringConvertible {
	public var value: Int? {
		didSet {
			if value != nil {
				pencilMarks = []
			}
		}
	}

	/// The row that the cell is in, numbered 1 through 9.
	public let row: Int

	/// The column that the cell is in, numbered 1 through 9.
	public let column: Int

	/// The box that the cell is in, numbered 1 through 9.
	public let box: Int

	public var pencilMarks: Set<Int>
	public var coordinate: Coordinate {
		try! .init(row: row, column: column, box: box)
	}

	public init(value: Int? = nil, coordinate: Coordinate) {
		self.init(value: value, row: coordinate.row, column: coordinate.column, box: coordinate.box)
	}

	init(value: Int? = nil, row: Int, column: Int, box: Int) {
		self.value = value
		self.row = row
		self.column = column
		self.box = box
		self.pencilMarks = value == nil ? [1,2,3,4,5,6,7,8,9] : []
	}

	public var hasValue: Bool { value != nil }

	public var description: String { value?.description ?? "-" }
	public var debugDescription: String {
		"\(description) (r\(row)c\(column)b\(box)) P:\(pencilMarks.sorted())"
	}
}

extension Sequence where Element == Cell {
	/// - Complexity: O(*n*) where *n* is the number of cells in the sequence.
	func cell(at coordinate: Coordinate) -> Cell {
		first { $0.coordinate == coordinate }!
	}

	/// - Complexity: O(*nm*) where *n* is the number of cells in the sequence and *m* is the number of coordinates passed in.
	func filter(at coordinates: [Coordinate]) -> [Cell] {
		filter { coordinates.contains($0.coordinate) }
	}

	/// - Complexity: O(*nm*) where *n* is the number of cells in the sequence and *m* is the number of coordinates passed in.
	func filter(at coordinates: Coordinate...) -> [Cell] {
		filter(at: coordinates)
	}

	/// - Complexity: O(*nm*) where *n* is the number of cells in the sequence and *m* is the number of coordinates passed in.
	func filter(notAt coordinates: [Coordinate]) -> [Cell] {
		filter { !coordinates.contains($0.coordinate) }
	}

	/// - Complexity: O(*nm*) where *n* is the number of cells in the sequence and *m* is the number of coordinates passed in.
	func filter(notAt coordinates: Coordinate...) -> [Cell] {
		filter(notAt: coordinates)
	}
}
