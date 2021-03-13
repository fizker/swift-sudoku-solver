public func solve(_ p: Puzzle) -> Puzzle {
	var puzzle = p

	while !puzzle.isSolved {
		let s = lastRemainingCell(puzzle: puzzle)
		if s != puzzle {
			puzzle = s
			continue
		}

		return puzzle
	}

	return puzzle
}
