/// - Complexity: O(1.175.737.662).
struct Jellyfish: Algorithm {
	static let name = "Jellyfish"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		let fish = Fish(puzzle: puzzle, type: .jellyfish)
		return fish.resolve(primaryGroupPath: \.rows, secondaryGroupPath: \.columns)
		?? fish.resolve(primaryGroupPath: \.columns, secondaryGroupPath: \.rows)
		?? puzzle
	}
}
