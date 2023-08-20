/// A hidden single is where only one cell in a column, row or group can contain a specific digit.
func hiddenSingle(_ puzzle: Puzzle) -> Puzzle {
	for var cell in puzzle.cells where !cell.hasValue {
		let cellCandidates = puzzle.candidates(for: cell)

		for container in puzzle.containers(for: cell) {
			var containerCandidates = [1,2,3,4,5,6,7,8,9].map { (value: $0, potentialCount: 0) }

			for cell in container.cells {
				let cellCandidates = puzzle.candidates(for: cell)
				for value in cellCandidates {
					let index = value - 1
					containerCandidates[index].potentialCount += 1
				}
			}

			for containerCandidate in containerCandidates where containerCandidate.potentialCount == 1 {
				if cellCandidates.contains(containerCandidate.value) {
					cell.value = containerCandidate.value
					return puzzle.updatingCell(cell)
				}
			}
		}
	}

	return puzzle
}
