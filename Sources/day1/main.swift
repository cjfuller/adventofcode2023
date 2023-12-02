import func aoc2024_shared.readInputLines

let input = try! readInputLines(day: 1)

func findDigits(s: String) -> (Int, Int) {
  let first = Int(String(s.first(where: { $0.isNumber })!))!
  let last = Int(String(s.last(where: { $0.isNumber })!))!
  return (first, last)
}

let textNumbers = [
  "one": "1",
  "two": "2",
  "three": "3",
  "four": "4",
  "five": "5",
  "six": "6",
  "seven": "7",
  "eight": "8",
  "nine": "9",
]

func replaceTextNumbers(_ s: String) -> String {
  var output = s
  for (str, repl) in textNumbers {
    output = output.replacingOccurrences(of: str, with: repl)
  }
  return output
}

let regexStr = [textNumbers.keys.joined(separator: "|"), textNumbers.values.joined(separator: "|")]
  .joined(separator: "|")
let regex = try! Regex(regexStr)
let revRegex = try! Regex(String(regexStr.reversed()))

func findDigitsOrText(s: String) -> (Int, Int) {
  let firstMatch = replaceTextNumbers(String((try! regex.firstMatch(in: s))![0].substring!))
  let lastMatch = replaceTextNumbers(
    String((try! revRegex.firstMatch(in: String(s.reversed())))![0].substring!.reversed()))
  return (Int(firstMatch)!, Int(lastMatch)!)
}

func replaceTextNumbers(s: String) -> String {
  let anyNumber = textNumbers.keys.joined(separator: "|")

  var result = s.replacingOccurrences(of: anyNumber, with: "[$0]", options: [.regularExpression])

  for (str, replacement) in textNumbers {
    result = result.replacingOccurrences(of: "[\(str)]", with: replacement)
  }
  //print("\(s) -> \(result)")
  return result
}

let sum = input.map({ String($0) }).map(findDigits).map({ (nums: (Int, Int)) -> Int in
  nums.0 * 10 + nums.1
})
.reduce(0, { (acc: Int, el: Int) -> Int in acc + el })

print("Part 1: \(sum)")

let sum2 = input.map({ String($0) }).map(findDigitsOrText).map({
  (nums: (Int, Int)) -> Int in
  nums.0 * 10 + nums.1
})
.reduce(0, { (acc: Int, el: Int) -> Int in acc + el })

print("Part 2: \(sum2)")

let testInput = [
  "two1nine",
  "eightwothree",
  "abcone2threexyz",
  "xtwone3four",
  "4nineeightseven2",
  "zoneight234",
  "7pqrstsixteen",
]

let test_sum = testInput.map(findDigitsOrText).map({ (nums: (Int, Int)) -> Int in
  nums.0 * 10 + nums.1
}).reduce(0, { (acc: Int, el: Int) -> Int in acc + el })

print("Test (p2): \(test_sum)")
