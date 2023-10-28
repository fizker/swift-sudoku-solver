public extension Array where Element == any Algorithm {
	/// Attempts to solve the given puzzle using the algorithms that this array contains.
	///
	/// The algorithms are attempted one at a time, in order. If the algorithm changes the puzzle in any way, the loop is restarted and all algorithms are retried in order against the new puzzle state.
	///
	/// The loop ends if the puzzle is considered solved or if no algorithms were capable of updating the puzzle.
	///
	/// - parameter puzzle: The puzzle to solve.
	/// - returns: The most solved state of the puzzle, given the available algorithms.
	func solve(_ puzzle: Puzzle) -> Puzzle {
		var puzzle = puzzle
		puzzle.pencilMarkKnownValues()

		runloop: while !puzzle.isSolved {
			solverloop: for algorithm in self {
				if let s = algorithm(puzzle) {
					puzzle = s
					continue runloop
				}
			}
			break runloop
		}

		return puzzle
	}
}

public func solve(_ p: Puzzle) -> Puzzle {
	return [Algorithm].all.solve(p)
}
