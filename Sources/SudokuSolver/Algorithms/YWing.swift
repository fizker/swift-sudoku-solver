/// - Complexity: O(81(81 + 20(9 + 2\*81 + 14 + 14))) -> O(328.941) for a reguler 9x9 sudoku puzzle.
struct YWing: Algorithm {
	static let name = "Y-Wing"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		// O(n)
		for cell in puzzle.cells where cell.pencilMarks.count == 2 {
			// O(81) + O(20) for the loop
			for pivotCell in puzzle.cells(pointingAt: [cell]) where pivotCell.pencilMarks.count == 2 {
				// O(81)
				let requestedPencilMarks = cell.pencilMarks.formingSymmetricDifference(pivotCell.pencilMarks)

				guard requestedPencilMarks.count == 2
				else { continue }

				// O(81) + O(20) for the loop
				for otherCell in puzzle.cells(pointingAt: [pivotCell]) where otherCell.pencilMarks == requestedPencilMarks {
					// O(9)
					let values = otherCell.pencilMarks.intersection(cell.pencilMarks)
					guard values.count == 1, let valueToRemove = values.first
					else { continue }

					//  O(2*81 + 14) returns max 14
					let cellsToUpdate = puzzle.cells(pointingAt: [cell, otherCell])
						.filter { $0.pencilMarks.contains(valueToRemove) }
					guard cellsToUpdate.isNotEmpty
					else { continue }

					var puzzle = puzzle
					// O(14)
					for var cell in cellsToUpdate {
						cell.pencilMarks.remove(valueToRemove)
						puzzle.update(cell)
					}
					return puzzle
				}
			}
		}

		return puzzle
	}
}
