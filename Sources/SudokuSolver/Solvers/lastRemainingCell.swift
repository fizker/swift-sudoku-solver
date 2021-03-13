let possibleValues = [1,2,3,4,5,6,7,8,9]

func lastRemainingCell(puzzle p: Puzzle) -> Puzzle {
	var puzzle = p

	var rowIndex = 0
	for row in puzzle.rows {
		defer { rowIndex += 1 }

		let missingValues = possibleValues.filter { !row.contains($0) }

		if missingValues.count == 1, let columnIndex = row.firstIndex(of: nil) {
			try! puzzle.updateCell(value: missingValues[0], rowIndex: rowIndex, columnIndex: columnIndex)
			return puzzle
		}
	}

	var columnIndex = 0
	for column in puzzle.columns {
		defer { columnIndex += 1 }

		let missingValues = possibleValues.filter { !column.contains($0) }

		if missingValues.count == 1, let rowIndex = column.firstIndex(of: nil) {
			try! puzzle.updateCell(value: missingValues[0], rowIndex: rowIndex, columnIndex: columnIndex)
			return puzzle
		}
	}

	return puzzle
}
