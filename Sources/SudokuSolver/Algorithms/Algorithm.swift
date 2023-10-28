/// A Sudoku algorithm that applies a discreet algorithm.
///
/// An algorithm is not always applicable to a concrete puzzle state. In this case, the algorithm effects no change.
public protocol Algorithm {
	/// The name of the algorithm.
	static var name: String { get }

	init()

	/// Executes the algorithm against the given puzzle.
	///
	/// The puzzle is returned unchanged if the algorithm failed to find the required state.
	///
	/// - parameter puzzle: The puzzle to examine.
	/// - returns: The puzzle after applying the algorithm. If the algorithm did not effect a change, `nil` should be returned.
	func callAsFunction(_ puzzle: Puzzle) -> Puzzle?
}

public extension Algorithm {
	/// The name of the algorithm.
	var name: String { Self.name }
}
