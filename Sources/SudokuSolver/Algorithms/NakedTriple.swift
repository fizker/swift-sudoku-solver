/// A naked pair is if two numbers can only exist twice in a container, and they only exist in the same two cells.
struct NakedTriple: Algorithm {
	static let name = "Naked triple"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		for container in puzzle.containers {
			let cells = container.cells.sorted(by: \.pencilMarks.count)
				.reversed()
				.filter { $0.pencilMarks.count <= 3 && !$0.hasValue }
			for cell in cells where cell.pencilMarks.count > 1 {
				var puzzle: Puzzle?
				if cell.pencilMarks.count == 3 {
					puzzle = resolveNakedTriple(cell: cell, pencilMarks: cell.pencilMarks)
				} else {
					for otherCell in cells where puzzle == nil && otherCell.pencilMarks.count == 2 {
						var pencilMarks = cell.pencilMarks
						if otherCell.pencilMarks.contains(anyOf: pencilMarks) {
							pencilMarks.formUnion(otherCell.pencilMarks)
							puzzle = resolveNakedTriple(cell: cell, pencilMarks: pencilMarks)
						}
					}
				}

				if let puzzle {
					return puzzle
				}
			}

			func resolveNakedTriple(cell: Cell, pencilMarks pencilMarksToFind: Set<Int>) -> Puzzle? {
				let others = cells.filter { $0 != cell && $0.pencilMarks.allSatisfy(pencilMarksToFind.contains(_:)) }

				guard others.count == 2
				else { return nil }

				let potentialsToAffect = puzzle.cells(pointingAt: others + [cell])
				guard potentialsToAffect.contains(where: { $0.pencilMarks.contains(anyOf: pencilMarksToFind) })
				else { return nil }

				var puzzle = puzzle
				for var cell in potentialsToAffect {
					pencilMarksToFind.forEach { cell.pencilMarks.remove($0) }
					puzzle.update(cell)
				}
				return puzzle
			}
		}

		return puzzle
	}
}
