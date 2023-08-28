protocol Algorithm {
	var name: String { get }

	func callAsFunction(_: Puzzle) -> Puzzle
}

public class Solver {
	private let algorithms: [Algorithm] = [
		NakedSingle(),
		HiddenSingle(),
		NakedPair(),
		HiddenPair(),
	]

	private var puzzle: Puzzle

	public init(puzzle: Puzzle) {
		self.puzzle = puzzle
	}

	public func solve() -> Puzzle {
		puzzle.pencilMarkKnownValues()

		runloop: while !puzzle.isSolved {
			solverloop: for algorithm in algorithms {
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
	let solver = Solver(puzzle: p)
	return solver.solve()
}
