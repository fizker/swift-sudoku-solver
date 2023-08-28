/// A hidden single is where only one cell in a column, row or group can contain a specific digit.
struct HiddenSingle: Algorithm {
	let name = "Hidden single"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		for var cell in puzzle.cells where !cell.hasValue {
			let cellCandidates = cell.pencilMarks

			for container in puzzle.containers(for: cell) {
				let containerCandidates = puzzle.candidateCount(for: container)

				for containerCandidate in containerCandidates where containerCandidate.count == 1 {
					if cellCandidates.contains(containerCandidate.value) {
						cell.value = containerCandidate.value
						return puzzle.updating(cell)
					}
				}
			}
		}

		return puzzle
	}
}
