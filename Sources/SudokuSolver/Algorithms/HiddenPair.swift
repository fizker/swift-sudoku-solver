/// A naked pair is if two numbers can only exist twice in a container, and they only exist in the same two cells.
struct HiddenPair: Algorithm {
	static let name = "Hidden pair"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		for container in puzzle.containers {
			let candidates = container.candidateCount
			let two = candidates
				.filter { $0.count == 2 }
				.map(\.value)

			for value in two {
				let cellsWithValue = container.cells.filter { $0.pencilMarks.contains(value) }
				for otherValue in two where otherValue != value {
					let cellsWithBothValues = cellsWithValue.filter { $0.pencilMarks.contains(otherValue) }

					// The cell might already be resolved with regards to naked pairs
					guard cellsWithBothValues.contains(where: { $0.pencilMarks != [value, otherValue] })
					else { continue }

					if cellsWithBothValues.count == 2 {
						var puzzle = puzzle
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
