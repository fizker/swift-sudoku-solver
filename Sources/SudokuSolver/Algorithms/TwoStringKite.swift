/// A 2-string kite eliminates pencil marks.
///
/// It works by identifying a column where there are only two candidates (C1, C2) for a digit and a row with only
/// two candidates for the same digit (R1, R2). If one of the row-candidates share a box with one of the
/// column-candidates, (C1 shares a box with R1), then the cell that sees the other two cells cannot contain the digit,
/// or both C1 and R1 would be forced to contain the digit.
///
/// - Complexity: O(522 + 9(738 + 9 + 9(9 + 2(9(9 + 2 + 162 + 7+ 7))))) -> O(280.620) for a reguler 9x9 sudoku puzzle.
struct TwoStringKite: Algorithm {
	static let name = "2-String Kite"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle? {
		// O(171 + 171 + 180)
		let columns = puzzle.columns
		let rows = puzzle.rows
		let boxes = puzzle.boxes

		// O(9n)
		for column in columns {
			// O(738 + 9), returns 9
			let twoCandidates = column.candidateCount.filter { $0.count == 2 }.map(\.value)

			// O(9)
			for digit in twoCandidates {
				// O(9)
				let cells = column.cells.filter { $0.pencilMarks.contains(digit) }

				// O(2)
				for cell in cells {
					let box = boxes[cell.box - 1]
					// O(9)
					for otherBoxCell in box.cells where otherBoxCell.pencilMarks.contains(digit) && cell.coordinate != otherBoxCell.coordinate {
						let row = rows[otherBoxCell.row - 1]
						// O(9)
						let rowCells = row.cells.filter { $0.pencilMarks.contains(digit) && $0.column != otherBoxCell.column }
						guard rowCells.count == 1
						else { continue }

						// O(2)
						let otherColumnCell = cells.first { $0.row != cell.row }!
						let otherRowCell = rowCells[0]

						// O(81*2)
						let cellsToUpdate = puzzle.cells(pointingAt: [
							otherColumnCell,
							otherRowCell,
						])

						// O(7)
						guard cellsToUpdate.contains(where: { $0.pencilMarks.contains(digit) })
						else { continue }

						var puzzle = puzzle
						// O(7)
						for var cell in cellsToUpdate {
							cell.pencilMarks.remove(digit)
							puzzle.update(cell)
						}
						return puzzle
					}
				}
			}
		}

		return nil
	}
}
