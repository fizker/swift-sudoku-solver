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

public struct Cell: Equatable, CustomStringConvertible, CustomDebugStringConvertible {
	public var value: Int?
	public let row: Int
	public let column: Int
	public let group: Int

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
