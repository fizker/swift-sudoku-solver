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

	init(puzzle: Puzzle, type: FishType) {
		self.puzzle = puzzle
		self.type = type

		// O(171 + 171)
		self.rows = puzzle.rows
		self.columns = puzzle.columns
	}

	func resolve(primaryGroupPath: KeyPath<Fish, [some Container]>, secondaryGroupPath: KeyPath<Fish, [some Container]>) -> Puzzle? {
		let primaryGroups = self[keyPath: primaryGroupPath]
		let groupsToAffect = self[keyPath: secondaryGroupPath]

		let requiredCandidateCount = Set(2...type.requiredMatches)
		let endIndex = primaryGroups.endIndex - type.requiredMatches

		for index in primaryGroups.startIndex..<endIndex {
			let group = primaryGroups[index]
			let candidates = group.candidateCount.filter { requiredCandidateCount.contains($0.count) }.sorted(by: \.count).reversed()

			for candidate in candidates {
				let fish = FishCandidate(groupType: group.type, fishType: type, digit: candidate.value)
					.formingCandidate(with: group)!

				let cellsToAffect = resolve(candidate: fish, groups: primaryGroups.dropFirst(index).dropFirst(), crossingGroups: groupsToAffect)

				guard cellsToAffect.isNotEmpty
				else { continue }

				var puzzle = puzzle
				for var cell in cellsToAffect {
					cell.pencilMarks.remove(candidate.value)
					puzzle.update(cell)
				}
				return puzzle
			}
		}

		return nil
	}

	private func resolve(candidate: FishCandidate, groups: ArraySlice<some Container>, crossingGroups: [some Container]) -> [Cell] {
		for index in groups.indices {
			let group = groups[index]

			guard let nextCandidate = candidate.formingCandidate(with: group)
			else { continue }

			let cellsToAffect = nextCandidate.affectedCells(in: crossingGroups)
			if cellsToAffect.isNotEmpty {
				return cellsToAffect
			}

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
		func formingCandidate(with group: some Container) -> FishCandidate? {
			guard group.type == groupType
			else { return nil }

			let requiredMatches = fishType.requiredMatches

			let candidateCells = group.cells.filter { $0.pencilMarks.contains(digit) }

			guard 2 <= candidateCells.count && candidateCells.count <= requiredMatches
			else { return nil }

			var newCandidate = self
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
		func affectedCells(in crossingGroups: [some Container]) -> [Cell] {
			guard isValid
			else { return [] }

			return positionInGroups.flatMap { index in
				let group = crossingGroups[index]
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
