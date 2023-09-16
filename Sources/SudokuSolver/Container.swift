public enum ContainerType { case row, column, box }

public protocol Container: Sequence, Equatable {
	var type: ContainerType { get }
	var cells: [Cell] { get }
	var position: Int { get }
}

public func ==(lhs: any Container, rhs: any Container) -> Bool {
	lhs.type == rhs.type && lhs.position == rhs.position && lhs.cells == rhs.cells
}
// We have to manually make this since we implement via `any` keyword
public func !=(lhs: any Container, rhs: any Container) -> Bool {
	!(lhs == rhs)
}

extension Container {
	public func makeIterator() -> IndexingIterator<[Cell]> { cells.makeIterator() }
	public var underestimatedCount: Int { cells.underestimatedCount }
	public func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Cell>) throws -> R) rethrows -> R? {
		try cells.withContiguousStorageIfAvailable(body)
	}
}

extension Container {
	/// Returns the number of candidates for each digit.
	///
	/// Any cell that can contain a digit is considered a candidate.
	///
	/// - Complexity: O(c+cn) where n is the number of cells in the puzzle and c is the number of potential digits (9).
	/// - Complexity: O(9 + 9 \* 81) -> O(738)
	/// - Returns: All digits along with a count of how many times they can potentially be entered into this group.
	var candidateCount: [(value: Int, count: Int)] {
		var containerCandidates = [1,2,3,4,5,6,7,8,9].map { (value: $0, count: 0) }

		for cell in cells {
			for value in cell.pencilMarks {
				let index = value - 1
				containerCandidates[index].count += 1
			}
		}

		return containerCandidates
	}
}

public struct Box: Container {
	public let type = ContainerType.box

	public let cells: [Cell]
	public let position: Int
}

public struct Column: Container {
	public let type = ContainerType.column

	public let cells: [Cell]
	public let position: Int
}

public struct Row: Container {
	public let type = ContainerType.row

	public let cells: [Cell]
	public let position: Int
}
