let possibleValues = [1,2,3,4,5,6,7,8,9]

func lastRemainingCell(puzzle p: Puzzle) -> Puzzle {
	var puzzle = p

	for container in [puzzle.rows, puzzle.columns, puzzle.groups] {
		for list in container {
			let missingValues = possibleValues.filter { value in !list.contains { $0.value == value } }

			if missingValues.count == 1, var cell = list.first(where: { !$0.hasValue }) {
				cell.value = missingValues[0]
				puzzle.updateCell(cell)
				return puzzle
			}
		}
	}

	return puzzle
}
