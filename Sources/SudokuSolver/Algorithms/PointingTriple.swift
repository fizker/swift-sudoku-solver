struct PointingTriple: Algorithm {
	static var name = "Pointing Triple"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		solvePointingCombination(puzzle, requiredMatches: .three)
	}
}
