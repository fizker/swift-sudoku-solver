struct PointingPair: Algorithm {
	static var name = "Pointing pair"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		for container in puzzle.containers {
			let candidates = puzzle.candidateCount(for: container)
			let valuesInPairs = candidates
				.filter { $0.count == 2 }
				.map(\.value)

			for value in valuesInPairs {
				let pair = container.cells.filter { $0.pencilMarks.contains(value) }
				assert(pair.count == 2, "We need exactly two for this algo to work")

				guard let intersectingContainer = puzzle.containers.first(where: { $0 != container && $0.cells.contains(pair) })
				else { continue }

				guard intersectingContainer.cells.filter(notAt: pair.map(\.coordinate)).contains(where: { $0.pencilMarks.contains(value) })
				else { continue }

				var puzzle = puzzle
				for var cell in intersectingContainer.cells.filter(notAt: pair.map(\.coordinate)) {
					cell.pencilMarks.remove(value)
					puzzle.update(cell)
				}
				return puzzle
			}
		}

		return puzzle
	}
}
