/// - Complexity: O(580.563) for a reguler 9x9 sudoku puzzle.
struct PointingTriple: Algorithm {
	static var name = "Pointing Triple"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle? {
		solvePointingCombination(puzzle, requiredMatches: .three)
	}
}
