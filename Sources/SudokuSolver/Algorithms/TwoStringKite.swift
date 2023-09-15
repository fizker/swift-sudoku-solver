/// A 2-string kite eliminates pencil marks.
///
/// It works by identifying a box where there are only two candidates (A1, B1) for a digit, and where these two
/// candidates does not share row or column. They both however must be part of a second two-candidate pair (A2, B2 respectively).
///
/// Any cells that then see both of their counterparts cannot have the value, since that would force both A1 and B1 to have the same value.
struct TwoStringKite: Algorithm {
	static let name = "2-String Kite"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		for box in puzzle.boxes {
			let twoCandidates = box.candidateCount.filter { $0.count == 2 }.map(\.value)

			for digit in twoCandidates {
				let cells = box.cells.filter { $0.pencilMarks.contains(digit) }

				let firstPair = cellsBeingSecondCandidate(in: puzzle, firstCandidate: cells[0], digit: digit)
				let secondPair = cellsBeingSecondCandidate(in: puzzle, firstCandidate: cells[1], digit: digit)

				guard firstPair.isNotEmpty && secondPair.isNotEmpty
				else { continue }

				for firstLeg in firstPair {
					for secondLeg in secondPair {
						let pointingCells = puzzle.cells(pointingAt: firstLeg, secondLeg)
						let cellsToUpdate = pointingCells
							.filter { $0.pencilMarks.contains(digit) }

						guard cellsToUpdate.isNotEmpty
						else { continue }

						var puzzle = puzzle
						for var cell in cellsToUpdate {
							cell.pencilMarks.remove(digit)
							puzzle.update(cell)
						}
						return puzzle
					}
				}
			}
		}

		return puzzle
	}

	func cellsBeingSecondCandidate(in puzzle: Puzzle, firstCandidate cell: Cell, digit: Int) -> [Cell] {
		let candidateGroups = [puzzle.rows[cell.row - 1] as any Container, puzzle.columns[cell.column - 1]]
			.filter { $0.candidateCount.contains { $0.value == digit && $0.count == 2 } }

		return candidateGroups.flatMap { $0.cells.filter { $0.pencilMarks.contains(digit) && $0 != cell } }
	}
}
