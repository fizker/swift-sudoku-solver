/// A hidden single is where only one cell in a column, row or box can contain a specific digit.
///
/// The result of a match finds a digit.
///
/// - Complexity: O(27(738 + 18)) -> O(20.412) for a regular 9x9 sudoku puzzle.
struct HiddenSingle: Algorithm {
	static let name = "Hidden single"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		// O(27)
		for container in puzzle.containers {
			// O(c+cn)
			let containerCandidates = container.candidateCount

			// O(9)
			guard let candidate = containerCandidates.first(where: { $0.count == 1 })
			else { continue }

			// O(9)
			var cell = container.cells.first { $0.pencilMarks.contains(candidate.value) }!
			cell.value = candidate.value
			return puzzle.updating(cell)
		}

		return puzzle
	}
}
