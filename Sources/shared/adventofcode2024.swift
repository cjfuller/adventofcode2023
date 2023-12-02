import Foundation

public func readInput(day: Int) throws -> String {
  try String(contentsOfFile: "./Inputs/day\(day).txt", encoding: .utf8)
}

public func readInputLines(day: Int) throws -> [String.SubSequence] {
  try readInput(day: day).split(separator: "\n")
}
