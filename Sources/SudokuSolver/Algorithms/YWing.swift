struct YWing: Algorithm {
	static let name = "Y-Wing"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		for cell in puzzle.cells where cell.pencilMarks.count == 2 {
			for pivotCell in puzzle.cells(pointingAt: [cell]) where pivotCell.pencilMarks.count == 2 {
				let requestedPencilMarks = cell.pencilMarks.formingSymmetricDifference(pivotCell.pencilMarks)

				guard requestedPencilMarks.count == 2
				else { continue }

				for otherCell in puzzle.cells(pointingAt: [pivotCell]) where otherCell.pencilMarks == requestedPencilMarks {
					let values = otherCell.pencilMarks.intersection(cell.pencilMarks)
					guard values.count == 1, let valueToRemove = values.first
					else { continue }

					let cellsToUpdate = puzzle.cells(pointingAt: [cell, otherCell]).filter { $0.pencilMarks.contains(valueToRemove) }
					guard !cellsToUpdate.isEmpty
					else { continue }

					var puzzle = puzzle
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
