let possibleValues = [1,2,3,4,5,6,7,8,9]

func lastRemainingCell(puzzle p: Puzzle) -> Puzzle {
	var puzzle = p

	for row in puzzle.rows {
		let missingValues = possibleValues.filter { value in !row.contains { $0.value == value } }

		if missingValues.count == 1, var cell = row.first(where: { !$0.hasValue }) {
			cell.value = missingValues[0]
			puzzle.updateCell(cell)
			return puzzle
		}
	}

	for column in puzzle.columns {
		let missingValues = possibleValues.filter { value in !column.contains { $0.value == value } }

		if missingValues.count == 1, var cell = column.first(where: { !$0.hasValue }) {
			cell.value = missingValues[0]
			puzzle.updateCell(cell)
			return puzzle
		}
	}

	return puzzle
}
