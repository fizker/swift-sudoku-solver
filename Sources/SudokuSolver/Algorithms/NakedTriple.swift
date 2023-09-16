/// A naked pair is if two numbers can only exist twice in a container, and they only exist in the same two cells.
///
/// - Complexity: O(27(9log9 + 9 + 9(9(9 + 9 + 276)))) -> O(643.453)
struct NakedTriple: Algorithm {
	static let name = "Naked triple"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		/// O(27)
		for container in puzzle.containers {
			// O(9log9 + 9)
			let cells = container.cells.sorted(by: \.pencilMarks.count)
				.reversed()
				.filter { $0.pencilMarks.count <= 3 && !$0.hasValue }

			// O(9)
			for cell in cells where cell.pencilMarks.count > 1 {
				var puzzle: Puzzle?
				if cell.pencilMarks.count == 3 {
					// O(276)
					puzzle = resolveNakedTriple(cell: cell, pencilMarks: cell.pencilMarks)
				} else {
					// O(9)
					for otherCell in cells where puzzle == nil && otherCell.pencilMarks.count == 2 {
						var pencilMarks = cell.pencilMarks
						// O(9)
						if otherCell.pencilMarks.contains(anyOf: pencilMarks) {
							// O(9)
							pencilMarks.formUnion(otherCell.pencilMarks)
							// O(276)
							puzzle = resolveNakedTriple(cell: cell, pencilMarks: pencilMarks)
						}
					}
				}

				if let puzzle {
					return puzzle
				}
			}

			/// - Complexity: O(9 + 243 + 12 + 12) -> O(276)
			func resolveNakedTriple(cell: Cell, pencilMarks pencilMarksToFind: Set<Int>) -> Puzzle? {
				// O(9)
				let others = cells.filter { $0 != cell && $0.pencilMarks.allSatisfy(pencilMarksToFind.contains(_:)) }

				guard others.count == 2
				else { return nil }

				// O(3*81), returns 12
				let potentialsToAffect = puzzle.cells(pointingAt: others + [cell])
				// O(12)
				guard potentialsToAffect.contains(where: { $0.pencilMarks.contains(anyOf: pencilMarksToFind) })
				else { return nil }

				var puzzle = puzzle
				// O(12)
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
