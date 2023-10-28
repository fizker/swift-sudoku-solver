/// Resets all pencil marks.
///
/// Note that this algorithm should never be part of the regular solve-list, as it would destroy the progress that most other algorithms do.
struct ResetPencilMarks: Algorithm {
	static let name = "Reset Pencil Marks"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle? {
		var puzzle = puzzle

		let allValues: Set<Int> = [1,2,3,4,5,6,7,8,9]

		for var cell in puzzle.cells {
			if cell.hasValue {
				cell.pencilMarks = []
			} else {
				cell.pencilMarks = allValues
			}
			puzzle.update(cell)
		}

		for var cell in puzzle.cells {
			guard !cell.hasValue
			else { continue }

			let candidates = puzzle.candidates(for: cell)

			for pencilMark in cell.pencilMarks where !candidates.contains(pencilMark) {
				cell.pencilMarks.remove(pencilMark)
				puzzle.update(cell)
			}
		}

		return puzzle
	}

	/// Convenience func for executing this algorithm in a throw-away manner.
	static func reset(_ puzzle: Puzzle) -> Puzzle {
		let reset = ResetPencilMarks()
		return reset(puzzle) ?? puzzle
	}
}
