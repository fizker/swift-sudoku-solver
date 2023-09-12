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

func solvePointingCombination(_ puzzle: Puzzle, requiredMatches: RequiredPointingMatches) -> Puzzle {
	for container in puzzle.containers {
		let candidates = container.candidateCount
		let values = candidates
			.filter { $0.count == requiredMatches.count }
			.map(\.value)

		for value in values {
			let cells = container.cells.filter { $0.pencilMarks.contains(value) }
			assert(cells.count == requiredMatches.count, "We need exactly two for this algo to work")

			guard let intersectingContainer = puzzle.containers.first(where: { $0 != container && cells.allSatisfy($0.cells.contains) })
			else { continue }

			let cellsToUpdate = intersectingContainer.cells.filter(notAt: cells.map(\.coordinate)).filter { $0.pencilMarks.contains(value) }

			guard !cellsToUpdate.isEmpty
			else { continue }

			var puzzle = puzzle
			for var cell in cellsToUpdate {
				cell.pencilMarks.remove(value)
				puzzle.update(cell)
			}
			return puzzle
		}
	}

	return puzzle
}
