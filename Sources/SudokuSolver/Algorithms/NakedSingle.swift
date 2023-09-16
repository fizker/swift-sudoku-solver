/// A naked single is when a cell can only contain one digit because other cells in either column, row or
/// box have eliminated the other digits.
///
/// The result of a match finds a digit.
///
/// - Complexity: O(n+3g) where n is the number of cells (81) and g is the number of cells in a group (9).
/// - Complexity: O(81+3 \* 9) -> O(108)
struct NakedSingle: Algorithm {
	static let name = "Naked single"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		for var cell in puzzle.cells where cell.pencilMarks.count == 1 {
			cell.value = cell.pencilMarks.first!
			return puzzle.updating(cell)
		}

		return puzzle
	}
}
