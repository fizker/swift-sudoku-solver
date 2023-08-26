public enum ContainerType { case row, column, group }

public protocol Container: Sequence {
	var type: ContainerType { get }
	var cells: [Cell] { get }
	var position: Int { get }
}

extension Container {
	public func makeIterator() -> IndexingIterator<[Cell]> { cells.makeIterator() }
	public var underestimatedCount: Int { cells.underestimatedCount }
	public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Cell>) throws -> R) rethrows -> R? {
		try cells.withContiguousStorageIfAvailable(body)
	}
}

public struct Group: Container {
	public let type = ContainerType.group

	public let cells: [Cell]
	public let position: Int
}

public struct Column: Container {
	public let type = ContainerType.group

	public let cells: [Cell]
	public let position: Int
}

public struct Row: Container {
	public let type = ContainerType.group

	public let cells: [Cell]
	public let position: Int
}

public struct Coordinate: Equatable {
	var row: Int
	var column: Int
	var group: Int

	init(row: Int, column: Int, group: Int) {
		self.row = row
		self.column = column
		self.group = group
	}

	init(row: Int, column: Int) {
		self.row = row
		self.column = column

		// This is now 0 for 1-3, 3 for 4-6, 6 for 7-9
		let rg = (row-1) / 3 * 3

		// This is now 0 for 1-3, 1 for 4-6, 2 for 7-9
		let cg = (column-1) / 3

		self.group = cg + 1 + rg
	}
}

public struct Cell: Equatable, CustomStringConvertible, CustomDebugStringConvertible {
	public var value: Int?
	public let row: Int
	public let column: Int
	public let group: Int
	public var coordinate: Coordinate {
		.init(row: row, column: column, group: group)
	}

	init(value: Int? = nil, row: Int, column: Int, group: Int) {
		self.value = value
		self.row = row
		self.column = column
		self.group = group
	}

	public var hasValue: Bool { value != nil }

	public var description: String { value?.description ?? "-" }
	public var debugDescription: String { "\(description) (r\(row)c\(column)g\(group))" }
}
