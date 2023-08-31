import XCTest
import SudokuSolver

class FullPuzzleSolutionTests: XCTestCase {
	func test__solve__puzzleWith4MissingValues() throws {
		let puzzle = try Puzzle(dsl: """
		831 764 259
		695 281 374
		-72 5-3 861

		153 829 647
		-87 4-6 132
		246 137 598

		768 915 423
		514 372 986
		329 648 715
		""")

		let solved = solve(puzzle)
		XCTAssertIsSolved(solved)
	}

	func test__solve__puzzleIsUnsolvable__theSolverReturnsThePuzzleUnsolved() throws {
		let puzzle = try Puzzle(dsl: """
		1-- --- ---
		--- --- ---
		--- --- ---

		--- --- ---
		--- --- ---
		--- --- ---

		--- --- ---
		--- --- ---
		--- --- ---
		""")

		let solved = solve(puzzle)
		XCTAssertFalse(solved.isSolved)
	}

	func test_solve_puzzleWithNakedSinglesOnly() throws {
		let puzzle = try Puzzle(dsl: """
			5-- 139 ---
			-21 -87 --9
			-98 -4- 5--

			48- 7-- 6--
			-3- 8-- -57
			2-- -9- -14

			-65 91- ---
			943 --8 -65
			7-2 --- --8
			"""
		)

		let solved = solve(puzzle)
		XCTAssertIsSolved(solved)
	}

	func test_solve_puzzleWithTwoHiddenSingles() throws {
		// G2 has only one option for 9, which should go in R1C6
		// G7 has only one option for 3, which should go in R8C2
		let puzzle = try Puzzle(dsl: """
			-5- 6-- 3--
			--9 --- ---
			--- -1- --9

			7-- 4-- 19-
			--- 8-- ---
			3-6 --1 -47

			9-- --- -3-
			--8 -96 --4
			1-4 38- -7-
			"""
		)

		let solved = solve(puzzle)
		XCTAssertIsSolved(solved)
	}

	func test__solve__puzzleWithHiddenSingles__puzzlesAreSolved() async throws {
		let dsl = """
		--- --- 9-1
		--8 1-- 3--
		-4- --- --5

		--9 685 -7-
		41- --2 ---
		-7- --- 6--

		9-- -38 ---
		--3 -5- ---
		7-- --- --6

		\(Array<Puzzle>.separator)

		--- --- 2--
		-2- 8-- -6-
		--- -9- -7-

		3-- 962 --7
		75- --- 9--
		--4 -5- ---

		--- --9 ---
		--7 --- 341
		--- -1- 5-2
		"""

		for puzzle in try parse(dsl) {
			let solved = solve(puzzle)
			XCTAssertIsSolved(solved)
		}
	}

	func test__puzzleWithHiddenPairs__puzzleIsSolved() async throws {
		let puzzle = try Puzzle(dsl: """
		-9- -5- ---
		-3- --- --1
		--- 21- -34

		5-- 89- ---
		1-- -2- --9
		-2- -46 ---

		-1- -35 --2
		8-- --- -5-
		4-- --- -1-
		"""
		)

		let solved = solve(puzzle)
		XCTAssertIsSolved(solved)
	}

	func test__puzzleWithPointingPair__puzzleIsSolved() async throws {
		let puzzle = try Puzzle(dsl: """
			-7- --2 ---
			--8 --1 -69
			6-4 --- ---

			--- -1- --2
			-1- 5-7 -3-
			--- 8-- --1

			4-- --8 --7
			--- -7- -1-
			--5 --- 94-
			"""
		)

		let solved = solve(puzzle)
		XCTAssertIsSolved(solved)
	}

	func test__solve__puzzleWithXWing__puzzleIsSolved() async throws {
		let puzzle = try Puzzle(dsl: """
			-3- --- --4
			5-6 --- -9-
			-9- 36- -8-

			2-- 6-- -5-
			9-- --7 8--
			-5- --2 --7

			--- -78 -3-
			-7- --- 1-8
			4-- --- -2-
			"""
		)

		let solved = solve(puzzle)
		XCTAssertIsSolved(solved)
	}
}

extension FullPuzzleSolutionTests {
	var separator: String { Array<Puzzle>.separator }

	func parse(_ dsl: String) throws -> Array<Puzzle> {
		try .init(dsl: dsl)
	}
}

extension Array where Element == Puzzle {
	static let separator = "-----------"
	init(dsl: String) throws {
		self = try dsl
			.components(separatedBy: Self.separator)
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.filter { !$0.isEmpty }
			.map(Puzzle.init(dsl:))
	}

	public init(stringLiteral value: StringLiteralType) {
		try! self.init(dsl: value)
	}
}
