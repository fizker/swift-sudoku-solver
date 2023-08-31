struct XWing: Algorithm {
	static let name = "X-Wing"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		resolveXWing(puzzle: puzzle, primaryContainerPath: \.columns, secondaryContainerPath: \.rows, secondaryCellPositionPath: \.row) ??
		resolveXWing(puzzle: puzzle, primaryContainerPath: \.rows, secondaryContainerPath: \.columns, secondaryCellPositionPath: \.column) ??
		puzzle
	}

	func resolveXWing(puzzle: Puzzle, primaryContainerPath: KeyPath<Puzzle, [some Container]>, secondaryContainerPath: KeyPath<Puzzle, [some Container]>, secondaryCellPositionPath: KeyPath<Cell, Int>) -> Puzzle? {
		for container in puzzle[keyPath: primaryContainerPath] {
			let candidates = container.candidateCount
			let potentialXWings = candidates.filter { $0.count == 2 }.map(\.value)

			guard !potentialXWings.isEmpty
			else { continue }

			for potentialXWingValue in potentialXWings {
				let cells = container.cells.filter { $0.pencilMarks.contains(potentialXWingValue) }

				for secondContainer in puzzle[keyPath: primaryContainerPath] where container != secondContainer {
					let secondCells = secondContainer.cells.filter { $0.pencilMarks.contains(potentialXWingValue) }

					guard secondCells.count == 2
					else { continue }

					// check if they overlap on rows
					guard cells[0][keyPath: secondaryCellPositionPath] == secondCells[0][keyPath: secondaryCellPositionPath] && cells[1][keyPath: secondaryCellPositionPath] == secondCells[1][keyPath: secondaryCellPositionPath]
					else { continue }

					let cellsInRows = puzzle[keyPath: secondaryContainerPath][cells[0][keyPath: secondaryCellPositionPath] - 1].cells + puzzle[keyPath: secondaryContainerPath][cells[1][keyPath: secondaryCellPositionPath] - 1].cells
					let cellsToUpdate = cellsInRows.filter(notAt: (cells+secondCells).map(\.coordinate))

					var puzzle = puzzle
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
