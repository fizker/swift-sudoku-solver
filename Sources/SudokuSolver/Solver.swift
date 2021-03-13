public class Solver {
	private let solvers = [
		nakedSingle(puzzle:),
	]

	private var puzzle: Puzzle

	public init(puzzle: Puzzle) {
		self.puzzle = puzzle
	}

	public func solve() -> Puzzle {
		runloop: while !puzzle.isSolved {
			solverloop: for solver in solvers {
				let s = solver(puzzle)
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
