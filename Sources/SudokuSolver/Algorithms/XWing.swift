/// - Complexity: O(90.252 \* 2) -> O(180.504) for a regular 9x9 sudoku puzzle.
struct XWing: Algorithm {
	static let name = "X-Wing"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle? {
		resolveXWing(puzzle: puzzle, primaryContainerPath: \.columns, secondaryContainerPath: \.rows, secondaryCellPositionPath: \.row) ??
		resolveXWing(puzzle: puzzle, primaryContainerPath: \.rows, secondaryContainerPath: \.columns, secondaryCellPositionPath: \.column)
	}

	/// - Complexity: O(171 \* 2 + 9(738 + 18 + 9(9 + 9(9 + 90 + 14))) -> O(90.252).
	func resolveXWing(puzzle: Puzzle, primaryContainerPath: KeyPath<Puzzle, [some Container]>, secondaryContainerPath: KeyPath<Puzzle, [some Container]>, secondaryCellPositionPath: KeyPath<Cell, Int>) -> Puzzle? {
		// 171 + 171
		let primaryContainers = puzzle[keyPath: primaryContainerPath]
		let secondaryContainers = puzzle[keyPath: secondaryContainerPath]

		// O(9n)
		for container in primaryContainers {
			// O(738)
			let candidates = container.candidateCount
			// O(9+9)
			let potentialXWings = candidates.filter { $0.count == 2 }.map(\.value)

			guard potentialXWings.isNotEmpty
			else { continue }

			// O(9)
			for potentialXWingValue in potentialXWings {
				// O(9) producing 2
				let cells = container.cells.filter { $0.pencilMarks.contains(potentialXWingValue) }

				// O(9n)
				for secondContainer in primaryContainers where container != secondContainer {
					// O(9) producing 2
					let secondCells = secondContainer.cells.filter { $0.pencilMarks.contains(potentialXWingValue) }

					guard secondCells.count == 2
					else { continue }

					// check if they overlap on rows
					guard cells[0][keyPath: secondaryCellPositionPath] == secondCells[0][keyPath: secondaryCellPositionPath] && cells[1][keyPath: secondaryCellPositionPath] == secondCells[1][keyPath: secondaryCellPositionPath]
					else { continue }

					let cellsInRows = secondaryContainers[cells[0][keyPath: secondaryCellPositionPath] - 1].cells + secondaryContainers[cells[1][keyPath: secondaryCellPositionPath] - 1].cells
					// O(18*4 + 4 + 14) -> O(90)
					let cellsToUpdate = cellsInRows.filter(notAt: (cells+secondCells).map(\.coordinate))
						.filter { $0.pencilMarks.contains(potentialXWingValue) }

					guard !cellsToUpdate.isEmpty
					else { continue }

					var puzzle = puzzle
					// O(14)
					for var cell in cellsToUpdate {
						cell.pencilMarks.remove(potentialXWingValue)
						puzzle.update(cell)
					}

					return puzzle
				}
			}
		}

		return nil
	}
}
