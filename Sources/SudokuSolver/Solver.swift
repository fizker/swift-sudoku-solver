protocol Algorithm {
	static var name: String { get }

	init()

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle
}

extension Algorithm {
	var name: String { Self.name }
}

public class Solver {
	private let algorithms: [Algorithm] = [
		NakedSingle(),
		HiddenSingle(),
		PointingPair(),
		NakedPair(),
		HiddenPair(),
		XWing(),
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
