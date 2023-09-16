/// - Complexity: O(580.563) for a reguler 9x9 sudoku puzzle.
struct PointingPair: Algorithm {
	static var name = "Pointing pair"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		solvePointingCombination(puzzle, requiredMatches: .two)
	}
}

enum RequiredPointingMatches {
	case two, three

	var count: Int {
		switch self {
		case .two: return 2
		case .three: return 3
		}
	}
}

/// - Complexity: O(522 + 27(738 + 9 + 9(9 + 2.187 + 90 + 18))) -> O(580.563).
func solvePointingCombination(_ puzzle: Puzzle, requiredMatches: RequiredPointingMatches) -> Puzzle {
	let containers = puzzle.containers
	for container in containers {
		let candidates = container.candidateCount
		let values = candidates
			.filter { $0.count == requiredMatches.count }
			.map(\.value)

		for value in values {
			// O(9)
			let cells = container.cells.filter { $0.pencilMarks.contains(value) }
			assert(cells.count == requiredMatches.count, "We need exactly two for this algo to work")

			// O(27*9*9) -> O(2.187)
			guard let intersectingContainer = containers.first(where: { $0 != container && cells.allSatisfy($0.cells.contains) })
			else { continue }

			// O(nm + n) -> O(9*9 + 9) -> O(90)
			let cellsToUpdate = intersectingContainer.cells
				.filter(notAt: cells.map(\.coordinate))
				.filter { $0.pencilMarks.contains(value) }

			guard cellsToUpdate.isNotEmpty
			else { continue }

			var puzzle = puzzle
			// O(9*2)
			for var cell in cellsToUpdate {
				cell.pencilMarks.remove(value)
				puzzle.update(cell)
			}
			return puzzle
		}
	}

	return puzzle
}
