/// A naked pair is if two numbers can only exist twice in a container, and they only exist in the same two cells.
///
/// - Complexity: O(522 + 27(738 + 9(9 + 9(9 + 9 + 2)))) -> O(66.375) for a reguler 9x9 sudoku puzzle.
struct HiddenPair: Algorithm {
	static let name = "Hidden pair"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		// O(522 + 27n)
		for container in puzzle.containers {
			// O(738)
			let candidates = container.candidateCount
			let two = candidates
				.filter { $0.count == 2 }
				.map(\.value)

			// O(9)
			for value in two {
				// O(9)
				let cellsWithValue = container.cells.filter { $0.pencilMarks.contains(value) }
				// O(9)
				for otherValue in two where otherValue != value {
					// O(9)
					let cellsWithBothValues = cellsWithValue.filter { $0.pencilMarks.contains(otherValue) }

					// The cell might already be resolved with regards to naked pairs
					// O(9)
					guard cellsWithBothValues.contains(where: { $0.pencilMarks != [value, otherValue] })
					else { continue }

					if cellsWithBothValues.count == 2 {
						var puzzle = puzzle
						// O(2)
						for var cell in cellsWithBothValues {
							cell.pencilMarks = [value, otherValue]
							puzzle.update(cell)
						}
						return puzzle
					}
				}
			}
		}

		return puzzle
	}
}
