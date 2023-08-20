/// A naked single is when a cell can only contain one digit because other cells in either column, row or
/// group have eliminated the other digits.
func nakedSingle(puzzle: Puzzle) -> Puzzle {
	for var cell in puzzle.cells {
		guard !cell.hasValue
		else { continue }

		let candidates = puzzle.candidates(for: cell)

		if candidates.count == 1 {
			cell.value = candidates[0]
			return puzzle.updatingCell(cell)
		}
	}

	return puzzle
}
