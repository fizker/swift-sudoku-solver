/// A naked pair is if two numbers can only exist twice in a container, and they only exist in the same two cells.
struct NakedPair: Algorithm {
	static let name = "Naked pair"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		for cell in puzzle.cells where cell.pencilMarks.count == 2 {
			for container in puzzle.containers(for: cell) {
				guard let other = container.cells.first(where: { $0 != cell && $0.pencilMarks == cell.pencilMarks })
				else { continue }

				// eliminate pencil marks in cells that see both
				let pointingCells = puzzle.cells(pointingAt: [ cell, other ])

				// If there is nothing to update, we skip
				guard pointingCells.contains(where: { $0.pencilMarks.contains(where: cell.pencilMarks.contains(_:)) })
				else { continue }

				var p = puzzle
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
