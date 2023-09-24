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

	func test__solve__puzzlesRequiringYWing__puzzlesAreSolved() throws {
		let dsl = """
		// This harbors a y-wing
		--1 --- ---
		2-- --6 -7-
		-5- -2- -3-

		--2 --9 --1
		--6 --- 24-
		7-- 5-- 38-
		-4- 38- -2-
		--- 4-- --7
		--- --- ---

		\(separator)

		// This harbors a y-wing
		-2- 1-9 -6-
		-14 -8- 2--
		--- --- ---

		--2 --- 9--
		6-- -75 ---
		--3 --- 8--

		--- --- -5-
		--7 -9- 14-
		-9- 4-2 -3-

		\(separator)

		// This eventually has a y-wing between R2C7 R3C5 R2C9 between 138
		--- 82- --9
		--- --- --2
		--4 5-- 6--

		-2- --- 7--
		79- -6- -23
		--8 --- ---

		--9 --4 1--
		4-- --- ---
		6-- -93 5--

		\(separator)

		// This harbors a y-wing
		--6 9-- ---
		-72 --1 ---
		3-- -57 -8-

		-6- --- 7-4
		--- -3- ---
		4-1 --- -2-

		-8- 6-- --7
		--- 32- 86-
		--- --5 3--
		"""

		for puzzle in try parse(dsl) {
			let solved = solve(puzzle)
			XCTAssertIsSolved(solved)
		}
	}

	func test__solve__puzzleWithNakedTriple__puzzleIsSolved() async throws {
		let puzzle = try Puzzle(dsl: """
			// This one solves until a naked triple between cells R4C7 R7C7 R9C7 on 359
			// This then opens the same naked triple in B9
			// This then collapses in a series of naked and hidden singles
			32- -5- -7-
			--- --- -3-
			9-- --8 6--

			--- 172 --4
			--- --- ---
			1-- 543 ---

			--6 2-- --8
			-7- --- ---
			-5- -84 -17
			"""
		)

		let solved = solve(puzzle)
		XCTAssertIsSolved(solved)
	}

	func test__solve__variousPuzzles__puzzlesAreSolved() throws {
		let dsl = """
		5-- 8-- -9-
		-9- --- 7--
		7-2 --- 1-4

		2-3 9-- 8--
		-7- --- -25
		--9 -8- -7-

		-6- --2 --7
		3-- 1-- 4--
		--- -3- ---

		\(separator)

		6-- 87- 3--
		-5- --- --4
		--9 --6 --2

		-72 --4 ---
		--- --- ---
		--- 3-- 68-

		3-- 7-- 5--
		2-- --- -7-
		--7 -25 --1

		\(separator)

		// This one gets an avoidable rectangle between R4+8 C7+8
		--- -82 3-7
		--- 9-- --5
		-1- -36 --8

		1-2 --- --3
		-5- -6- -4-
		--- --- 6-9

		--- -5- -3-
		7-- --- ---
		528 67- ---

		\(separator)

		// This includes a 2-string kite
		--5 --- -6-
		-69 47- ---
		--- --2 7--

		--1 --- -2-
		8-- 21- -9-
		9-- -3- 47-

		-1- --8 -5-
		--6 --4 1--
		--- 1-- 8-6

		\(separator)

		// This requires a Swordfish
		2-- -7- 1-3
		-7- -8- -5-
		3-- --6 ---

		--6 --- ---
		91- -5- -28
		--- --- 5--

		--- 3-- --4
		-2- -9- -7-
		5-4 -1- --6

		"""

		for puzzle in try parse(dsl) {
			let solved = solve(puzzle)
			XCTAssertIsSolved(solved)
		}
	}

	func test__fromGoodSudoku() async throws {
		let dsl = """
			// This dies on an X-wing on 8 in R1+6 C1+4, clearing the rows
			--- -7- 5-3
			4-8 --- -1-
			--- --2 89-

			-4- -95 7-8
			--7 -2- 9--
			8-5 -4- -2-

			3-6 --- ---
			-8- 3-- -72
			2-4 -1- ---

			\(separator)

			9-- 3-- -46
			735 4-- ---
			--- -9- -5-

			2-- -6- -9-
			--3 -27 1--
			-87 1-- -3-

			--9 -3- ---
			--- --1 46-
			84- --5 --3

			\(separator)

			--- 6-- 4--
			--6 -24 ---
			-37 --9 25-

			--- --- --9
			-9- 236 ---
			8-- --- ---

			-2- 1-- 54-
			--5 34- 8--
			--3 --8 -1-

			\(separator)

			--- 6-- --8
			2-8 --- ---
			-67 --3 2--

			-5- --- 9--
			--1 5-7 82-
			--6 --- -5-

			7-5 4-- ---
			--- --5 1-3
			6-- --2 ---

			\(separator)

			--2 --7 -1-
			--- --4 --7
			-3- --6 -8-

			4-- --- -2-
			1-- 5-8 --9
			-7- --- --8

			78- --- -3-
			6-- 7-2 ---
			--- 6-- 9--

			\(separator)

			5-- 7-- --2
			-3- --- 19-
			--- -2- 37-

			--- --2 51-
			--4 --- ---
			-69 8-- ---

			-25 -6- ---
			-4- --- -6-
			6-- --1 --8

			\(separator)

			39- -14 2--
			--- 2-- --3
			-7- --- 9--

			-1- 3-- ---
			--- 158 --7
			--- --7 -9-

			--4 --- -3-
			2-- --1 ---
			--7 -3- -54

			\(separator)

			-14 8-7 ---
			--- 4-- -3-
			8-- 19- ---

			52- -3- ---
			--7 --- 1--
			--- -6- -57

			--- -72 --4
			--- --- -6-
			--- 9-8 3--

			\(separator)

			-6- 4-8 -2-
			--5 3-- ---
			--8 -7- --1

			--- --- -73
			8-4 --- 9-5
			5-- --- ---

			9-- -3- 6--
			--- --6 4--
			-4- 8-5 -3-
			"""

		for puzzle in try parse(dsl) {
			let solved = solve(puzzle)
			XCTAssertIsSolved(solved)
		}
	}

	func test__solve__puzzleRequiresJellyfishTechnique__solvesPuzzle() throws {
		// A Jellyfish is basically a 4x4 variant of the x-wing pattern.
		// Unlike an x-wing, it is OK if one of the rows/columns are empty
		// Specifically for this puzzle, the 7s, 8s and 9s all create a Jellyfish
		// pattern right from the starting state

		let puzzle = try Puzzle(dsl: """
			-1- --- -2-
			3-- --- --7
			--4 5-2 1--

			--6 4-5 2--
			--- --- ---
			--1 3-6 5--

			--5 6-4 3--
			6-- --- --2
			-8- --- -9-
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
	init(dsl: String, pencilMarked: Bool = false) throws {
		self = try dsl
			.components(separatedBy: Self.separator)
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.filter { !$0.isEmpty }
			.map { try Puzzle(dsl:$0, pencilMarked: pencilMarked) }
	}

	public init(stringLiteral value: StringLiteralType) {
		try! self.init(dsl: value)
	}
}
