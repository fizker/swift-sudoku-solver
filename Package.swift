// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SudokuSolver",
	products: [
		.library(
			name: "SudokuSolver",
			targets: ["SudokuSolver"]
		),
	],
	dependencies: [
	],
	targets: [
		.target(
			name: "SudokuSolver",
			dependencies: []
		),
		.testTarget(
			name: "SudokuSolverTests",
			dependencies: ["SudokuSolver"]
		),
	]
)
