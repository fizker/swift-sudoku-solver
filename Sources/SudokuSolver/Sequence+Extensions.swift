extension Collection {
	var isNotEmpty: Bool { !isEmpty }
}

extension Sequence {
	/// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
	func sorted(by path: KeyPath<Element, some Comparable>) -> [Element] {
		sorted { $0[keyPath: path] < $1[keyPath: path] }
	}
}

extension Sequence where Element: Equatable {
	/// Tests whether this sequence contains at least one element also present in the given sequence.
	///
	/// - Complexity: O(*mn*), where *m* is the length of this sequence and *n* is the length of the given sequence.
	func contains<T: Sequence>(anyOf other: T) -> Bool where T.Element == Element {
		for item in other {
			if contains(item) {
				return true
			}
		}

		return false
	}
}

extension Set {
	/// - Complexity: O(*n*+*m*) where *n* is the number of items in the first set and *m* is the number of items in the second set.
	func formingSymmetricDifference(_ other: Set<Element>) -> Set<Element> {
		var copy = self
		copy.formSymmetricDifference(other)
		return copy
	}
}
