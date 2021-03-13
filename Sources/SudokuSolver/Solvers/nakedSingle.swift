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
