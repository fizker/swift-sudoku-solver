/// A naked single is when a cell can only contain one digit because other cells in either column, row or
/// group have eliminated the other digits.
func nakedSingle(puzzle: Puzzle) -> Puzzle {
	for var cell in puzzle.cells where cell.pencilMarks.count == 1 {
		cell.value = cell.pencilMarks.first!
		return puzzle.updating(cell)
	}

	return puzzle
}
