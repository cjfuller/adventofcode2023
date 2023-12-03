// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Adventofcode2024",
  platforms: [
    .macOS(.v14)
  ],
  dependencies: [],
  targets: [
    .target(
      name: "aoc2024_shared", path: "Sources/shared"),
    .executableTarget(
      name: "day1", dependencies: ["aoc2024_shared"], path: "Sources/day1"),
    .executableTarget(
      name: "day2", dependencies: ["aoc2024_shared"], path: "Sources/day2"),
  ]
)
