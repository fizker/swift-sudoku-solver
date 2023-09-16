/// A naked pair is if two numbers can only exist twice in a container, and they only exist in the same two cells.
///
/// The result of a match updates pencil marks.
///
/// - Complexity: O(n(3(2n + m + 2p)) -> O(6nn + 3mn + 6pn) where n is the number of cells
///   in the puzzle, m is the number of cells in a group and p is the number of cells that can point at two cells.
/// - Complexity: O(6 \* 81 \* 81 + 3 \* 9 \* 81 + 6 \* 14 \* 81) -> O(48.357).
struct NakedPair: Algorithm {
	static let name = "Naked pair"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		// O(n) where n is 81
		for cell in puzzle.cells where cell.pencilMarks.count == 2 {
			// Loop is O(3(m + 2n + p + p) where n is 81, p is 14 and m is 9
			for container in puzzle.containers(for: cell) {
				// O(m) where m is number of cells in a group (9)
				guard let other = container.cells.first(where: { $0 != cell && $0.pencilMarks == cell.pencilMarks })
				else { continue }

				// eliminate pencil marks in cells that see both
				// O(2n) where n is number of cells (81)
				// Establishes p as a number equal to either 14 or 7.
				let pointingCells = puzzle.cells(pointingAt: [ cell, other ])

				// If there is nothing to update, we skip
				// O(p)
				guard pointingCells.contains(where: { $0.pencilMarks.contains(where: cell.pencilMarks.contains(_:)) })
				else { continue }

				var p = puzzle
				// O(p) where m is the number of cells in a group
				for var c in pointingCells {
					c.pencilMarks = c.pencilMarks.subtracting(cell.pencilMarks)
					p.update(c)
				}

				return p
			}
		}

		return puzzle
	}
}
