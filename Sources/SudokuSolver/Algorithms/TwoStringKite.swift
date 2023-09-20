/// A 2-string kite eliminates pencil marks.
///
/// It works by identifying a box where there are only two candidates (A1, B1) for a digit, and where these two
/// candidates does not share row or column. They both however must be part of a second two-candidate pair (A2, B2 respectively).
///
/// Any cells that then see both of their counterparts cannot have the value, since that would force both A1 and B1 to have the same value.
///
/// - Complexity: O(180 + 9(738 + 9 + 9(9 + 3.708 + 18(18(162 + 14 + 14))))) -> O(5.294.340) for a reguler 9x9 sudoku puzzle.
struct TwoStringKite: Algorithm {
	static let name = "2-String Kite"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		// 180 + O(9)
		for box in puzzle.boxes {
			// O(738 + 9), returns 9
			let twoCandidates = box.candidateCount.filter { $0.count == 2 }.map(\.value)

			// O(9)
			for digit in twoCandidates {
				// O(9)
				let cells = box.cells.filter { $0.pencilMarks.contains(digit) }

				// O(2 * 1.854)
				let firstPair = cellsBeingSecondCandidate(in: puzzle, firstCandidate: cells[0], digit: digit)
				let secondPair = cellsBeingSecondCandidate(in: puzzle, firstCandidate: cells[1], digit: digit)

				guard firstPair.isNotEmpty && secondPair.isNotEmpty
				else { continue }

				// O(18)
				for firstLeg in firstPair {
					// O(18)
					for secondLeg in secondPair {
						// O(81 * 2), returns 14
						let pointingCells = puzzle.cells(pointingAt: firstLeg, secondLeg)
						// O(14)
						let cellsToUpdate = pointingCells
							.filter { $0.pencilMarks.contains(digit) }

						guard cellsToUpdate.isNotEmpty
						else { continue }

						var puzzle = puzzle
						// O(14)
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

	/// - Complexity: O(171 \* 2 + 2 \* 747 + 18) -> O(1.854)
	/// - Returns: A maximum of 18 cells.
	func cellsBeingSecondCandidate(in puzzle: Puzzle, firstCandidate cell: Cell, digit: Int) -> [Cell] {
		// O(171 * 2 + 2(738 + 9))
		let candidateGroups = [puzzle.rows[cell.row - 1] as any Container, puzzle.columns[cell.column - 1]]
			.filter {
				// O(738)
				$0.candidateCount
					// O(9)
					.contains { $0.value == digit && $0.count == 2 }

			}

		// O(2 * 9)
		return candidateGroups.flatMap { $0.cells.filter { $0.pencilMarks.contains(digit) && $0 != cell } }
	}
}
