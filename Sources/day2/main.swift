import func aoc2024_shared.readInputLines

struct BagContents {
  var red: Int
  var green: Int
  var blue: Int

  func power() -> Int {
    self.red * self.green * self.blue
  }
}

struct Draw {
  var red: Int
  var green: Int
  var blue: Int

  static let red_re = #/(\d+) red/#
  static let green_re = #/(\d+) green/#
  static let blue_re = #/(\d+) blue/#

  init(parsing: String) throws {
    self.red = Int(String(try Draw.red_re.firstMatch(in: parsing)?.1 ?? "0")) ?? 0
    self.green = Int(String(try Draw.green_re.firstMatch(in: parsing)?.1 ?? "0")) ?? 0
    self.blue = Int(String(try Draw.blue_re.firstMatch(in: parsing)?.1 ?? "0")) ?? 0
  }

  func isPossible(with bag: BagContents) -> Bool {
    self.red <= bag.red && self.green <= bag.green && self.blue <= bag.blue
  }
}

enum Day2Error: Error {
  case NotAGame
}

struct Game {
  var draws: [Draw]
  var id: Int

  static let game_re = #/Game (\d+):/#

  init(parsing: String) throws {
    guard let idStr = try Game.game_re.firstMatch(in: parsing)?.1 else {
      throw Day2Error.NotAGame
    }
    guard let id = Int(idStr) else {
      throw Day2Error.NotAGame
    }
    self.id = id
    let drawsStr = String(parsing.split(separator: ":").last!)
    self.draws = []
    for draw in drawsStr.split(separator: ";") {
      self.draws.append(try Draw(parsing: String(draw)))
    }
  }

  func isPossible(with bag: BagContents) -> Bool {
    self.draws.allSatisfy({ $0.isPossible(with: bag) })
  }

  func minPossibleBag() -> BagContents {
    var bag = BagContents(red: 0, green: 0, blue: 0)
    for draw in self.draws {
      bag.red = max(bag.red, draw.red)
      bag.green = max(bag.green, draw.green)
      bag.blue = max(bag.blue, draw.blue)
    }
    return bag
  }
}

let input = try! readInputLines(day: 2).map({ try! Game(parsing: String($0)) })
let part1 = input.filter({ $0.isPossible(with: BagContents(red: 12, green: 13, blue: 14)) })
  .map({ $0.id }).reduce(0, { $0 + $1 })

print("Part 1: \(part1)")

let part2 = input.map({ $0.minPossibleBag() }).map({ $0.power() }).reduce(0, { $0 + $1 })

print("Part 2: \(part2)")
