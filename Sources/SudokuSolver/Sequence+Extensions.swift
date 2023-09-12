extension Sequence where Element: Equatable {
	func sorted(by path: KeyPath<Element, some Comparable>) -> [Element] {
		sorted { $0[keyPath: path] < $1[keyPath: path] }
	}

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
	func formingSymmetricDifference(_ other: Set<Element>) -> Set<Element> {
		var copy = self
		copy.formSymmetricDifference(other)
		return copy
	}
}
