public protocol Algorithm {
	/// The name of the algorithm.
	static var name: String { get }

	init()

	/// Executes the algorithm against the given puzzle.
	///
	/// The puzzle is returned unchanged if the algorithm failed to find the required state.
	///
	/// - parameter puzzle: The puzzle to examine.
	/// - returns: The puzzle after applying the algorithm. The puzzle might not have changed.
	func callAsFunction(_ puzzle: Puzzle) -> Puzzle
}

public extension Algorithm {
	/// The name of the algorithm.
	var name: String { Self.name }
}

public extension Array where Element == any Algorithm {
	/// All supported algorithms.
	///
	/// They are ordered somewhat for performance, so that cheaper or more common algorithms are attempted first.
	static var all: [any Algorithm] { [
		NakedSingle(),
		HiddenSingle(),
		PointingPair(),
		PointingTriple(),
		NakedPair(),
		HiddenPair(),
		XWing(),
		YWing(),
		NakedTriple(),
	] }

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
				let s = algorithm(puzzle)
				if s != puzzle {
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
