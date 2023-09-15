public extension Array where Element == any Algorithm {
	/// All supported algorithms.
	///
	/// They are ordered somewhat for performance, so that cheaper or more common algorithms are attempted first.
	static var all: [Element] { [
		NakedSingle(),
		HiddenSingle(),
		PointingPair(),
		PointingTriple(),
		NakedPair(),
		HiddenPair(),
		XWing(),
		YWing(),
		NakedTriple(),
		TwoStringKite(),
	] }
}
