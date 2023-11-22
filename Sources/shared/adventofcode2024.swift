import Foundation

public func readInput(day: Int) throws -> String {
  try String(contentsOfFile: "./Inputs/day\(day).txt", encoding: .utf8)
}
