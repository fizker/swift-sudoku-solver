/// - Complexity: O(1.175.739.966).
struct Swordfish: Algorithm {
	static let name = "Swordfish"

	func callAsFunction(_ puzzle: Puzzle) -> Puzzle {
		let fish = Fish(puzzle: puzzle, type: .swordfish)
		return fish.resolve(primaryGroupPath: \.rows, secondaryGroupPath: \.columns)
		?? fish.resolve(primaryGroupPath: \.columns, secondaryGroupPath: \.rows)
		?? puzzle
	}
}

struct Fish {
	let puzzle: Puzzle
	let type: FishType

	let rows: [Row]
	let columns: [Column]

	/// - Complexity: O(342)
	init(puzzle: Puzzle, type: FishType) {
		self.puzzle = puzzle
		self.type = type

		// O(171 + 171)
		self.rows = puzzle.rows
		self.columns = puzzle.columns
	}

	/// - Complexity: O(6(756 + 9(18+10.886.355+21))) for Swordfish, O(5(756 + 9(18+13.063.626+20)))
	func resolve(primaryGroupPath: KeyPath<Fish, [some Container]>, secondaryGroupPath: KeyPath<Fish, [some Container]>) -> Puzzle? {
		let primaryGroups = self[keyPath: primaryGroupPath]
		let groupsToAffect = self[keyPath: secondaryGroupPath]

		let requiredCandidateCount = Set(2...type.requiredMatches)
		let endIndex = primaryGroups.endIndex - type.requiredMatches

		// O(6n) for Swordfish, O(5n) for Jellyfish
		for index in primaryGroups.startIndex..<endIndex {
			let group = primaryGroups[index]
			// O(738 + 9 + 9log9) -> O(756)
			let candidates = group.candidateCount.filter { requiredCandidateCount.contains($0.count) }.sorted(by: \.count).reversed()

			// O(9n), OS(9(18+10.886.355+21)), OJ(9(18+13.063.626+20))
			for candidate in candidates {
				// O(18)
				let fish = FishCandidate(groupType: group.type, fishType: type, digit: candidate.value)
					.formingCandidate(with: group)!

				// O(10.886.355) for Swordfish, O(13.063.626) for Jellyfish
				let cellsToAffect = resolve(candidate: fish, groups: primaryGroups.dropFirst(index).dropFirst(), crossingGroups: groupsToAffect)

				guard cellsToAffect.isNotEmpty
				else { continue }

				var puzzle = puzzle
				// O(21) for Swordfish, O(20) for Jellyfish
				for var cell in cellsToAffect {
					cell.pencilMarks.remove(candidate.value)
					puzzle.update(cell)
				}
				return puzzle
			}
		}

		return nil
	}

	/// - Complexity: O(10.886.355) for Swordfish, O(13.063.626) for Jellyfish.
	private func resolve(candidate: FishCandidate, groups: ArraySlice<some Container>, crossingGroups: [some Container]) -> [Cell] {
		// O(n(45 + m) + m) where n is group size and m is the complexity result of this function for n-1
		// If n is 1, this is O(18+27) -> O(45), O(54) for Jellyfish
		// - n: 2, O(2(45) + (45)) -> O(135), O(162) for J
		// - n: 3, O(3(45 + 2g) + 2g) -> O(3(180) + 135) -> O(675), O(810) for J
		// - n: 4, O(4(45 + 675) + 675) -> O(3.555), O(4.266) for J
		// - n: 5, O(5(45 + 3.555) + 3.555) -> O(21.555), O(25.866) for J
		// - n: 6, O(6(45 + 21.555) + 21.555) -> O(151.155), O(181.386) for J
		// - n: 7, O(7(45 + 151.155) + 151.155) -> O(1.209.555), O(1.451.466) for J
		// - n: 8, O(8(45 + 1.209.555) + 1.209.555) -> O(10.886.355), O(13.063.626) for J
		// O(8n) where n is 8 or less
		for index in groups.indices {
			let group = groups[index]

			// O(18)
			guard let nextCandidate = candidate.formingCandidate(with: group)
			else { continue }

			// O(27) for Swordfish, O(36) for jellyfish.
			let cellsToAffect = nextCandidate.affectedCells(in: crossingGroups)
			if cellsToAffect.isNotEmpty {
				return cellsToAffect
			}

			// O(n + m). groups will have size 7-
			let recursiveSolve = resolve(candidate: nextCandidate, groups: groups.drop { $0.position <= group.position }, crossingGroups: crossingGroups)
			if recursiveSolve.isNotEmpty {
				return recursiveSolve
			}
		}

		return []
	}

	private struct FishCandidate {
		/// The direction of the group, ie. if this represents a Fish on rows or columns.
		var groupType: ContainerType

		/// The type of Fish that this candidate represents.
		var fishType: FishType

		/// The digit that is a candidate
		var digit: Int

		/// The groups that are involved. These are 1-indexed to make comparing against cell coordinate easier.
		var groups: Set<Int> = []

		/// The 0-indexed position within the groups. If the group is a column, this should correspond to the index of the rows.
		var positionInGroups: Set<Int> = []

		/// Returns whether the candidate conforms to the rules of the ``fishType``.
		///
		/// - Complexity: O(1).
		var isValid: Bool {
			switch groupType {
			case .row, .column:
				return groups.count == fishType.requiredMatches && positionInGroups.count == fishType.requiredMatches
			case .box:
				return false
			}
		}

		/// The KeyPath of the cell that contains the position of groups on the Fish line.
		var cellPrimaryKeypath: KeyPath<Cell, Int> {
			switch groupType {
			case .row:
				return \.row
			case .column:
				return \.column
			case .box:
				return \.column
			}
		}
		/// The KeyPath to the cell that contains the position of groups  on the crossing line.
		var cellCrossingKeypath: KeyPath<Cell, Int> {
			switch groupType {
			case .row:
				return \.column
			case .column:
				return \.row
			case .box:
				return \.column
			}
		}

		/// Adds the cell to the candidate.
		///
		/// If the cell does not have the digit of the candidate, the cell will not be added.
		///
		/// - Complexity: O(1).
		mutating func add(_ cell: Cell) {
			guard cell.pencilMarks.contains(digit)
			else { return }
			groups.insert(cell[keyPath: cellPrimaryKeypath])
			positionInGroups.insert(cell[keyPath: cellCrossingKeypath] - 1)
		}

		/// Returns either nil or a potentially-valid candidate that can be formed by adding the given group
		/// to the current candidate.
		///
		/// For example, if this is a Swordfish candidate (requiring 3 rows and 3 columns) and it only
		/// contains 1 row stretching on 2 columns, the returned candidate will contain 2 rows (not yet valid)
		/// and either 2 or 3 columns, depending on the overlap.
		///
		/// But if the group would have 3 columns where only one overlapped the already known column,
		/// this would then match 4 columns which is too much and thus return nil.
		///
		/// - Complexity: O(18).
		func formingCandidate(with group: some Container) -> FishCandidate? {
			guard group.type == groupType
			else { return nil }

			let requiredMatches = fishType.requiredMatches

			// O(9)
			let candidateCells = group.cells.filter { $0.pencilMarks.contains(digit) }

			guard 2 <= candidateCells.count && candidateCells.count <= requiredMatches
			else { return nil }

			var newCandidate = self
			// O(9)
			for cell in candidateCells {
				newCandidate.add(cell)
			}

			guard newCandidate.positionInGroups.count <= requiredMatches && newCandidate.groups.count <= requiredMatches
			else { return nil }

			return newCandidate
		}

		/// Returns the cells that would be affected by this candidate.
		///
		/// If ``isValid`` is false, this always returns no cells.
		///
		/// - Complexity: O(9`m`) where `m` is the order of the Fish, eg. it is 3 for a Swordfish and 4 for a Jellyfish. See ``FishType`` for more details on Fish order.
		func affectedCells(in crossingGroups: [some Container]) -> [Cell] {
			guard isValid
			else { return [] }

			// O(`m`n) where `m` is 3 for Swordfish and 4 for Jellyfish.
			return positionInGroups.flatMap { index in
				let group = crossingGroups[index]

				// O(9)
				return group.cells.filter {
					$0.pencilMarks.contains(digit) && !groups.contains($0[keyPath: cellPrimaryKeypath])
				}
			}
		}
	}

	enum FishType {
		case swordfish, jellyfish

		/// The required number of matches for this to be a valid pattern.
		var requiredMatches: Int {
			switch self {
			case .swordfish: return 3
			case .jellyfish: return 4
			}
		}
	}
}
