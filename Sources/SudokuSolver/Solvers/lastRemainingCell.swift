let possibleValues = [1,2,3,4,5,6,7,8,9]

func lastRemainingCell(puzzle p: Puzzle) -> Puzzle {
	var puzzle = p

	var rowIndex = 0
	for row in puzzle.rows {
		defer { rowIndex += 1 }

		let missingValues = possibleValues.filter { !row.contains($0) }

		if missingValues.count == 1, let columnIndex = row.firstIndex(of: nil) {
			puzzle.cells[rowIndex * 9 + columnIndex] = missingValues[0]
			break
		}
	}

	return puzzle
}
