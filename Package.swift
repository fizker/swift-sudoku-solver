// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SudokuSolver",
	platforms: [ .macOS(.v13) ],
	products: [
		.library(
			name: "SudokuSolver",
			targets: ["SudokuSolver"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/fizker/swift-extensions.git", from:"1.2.0"),
	],
	targets: [
		.target(
			name: "SudokuSolver",
			dependencies: [
				.product(name: "FzkExtensions", package: "swift-extensions"),
			]
		),
		.testTarget(
			name: "SudokuSolverTests",
			dependencies: ["SudokuSolver"]
		),
	]
)
