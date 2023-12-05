import Foundation

import func aoc2024_shared.readInputLines

func parseNums(from input: String) -> Set<Int> {
  Set(
    input.trimmingCharacters(in: CharacterSet.whitespaces).split(
      separator: " ", omittingEmptySubsequences: true
    ).map({ Int($0)! }))
}

struct Card {
  var index: Int
  var winning_nums: Set<Int>
  var my_nums: Set<Int>

  static func parse(from input: String) -> Card {
    let card_re = #/Card +(\d+): ([^|]+) \| (.*)/#
    let match = try! card_re.firstMatch(in: input)!
    return Card(
      index: Int(match.1)!,
      winning_nums: parseNums(from: String(match.2)),
      my_nums: parseNums(from: String(match.3))
    )
  }

  func win_count() -> Int {
    self.winning_nums.intersection(self.my_nums).count
  }

  func score() -> Int {
    let num_winning = self.win_count()
    if num_winning == 0 {
      return 0
    } else {
      return 1 << (num_winning - 1)
    }
  }
}

let total = try! readInputLines(day: 4).map(String.init).map(Card.parse).map({
  $0.score()
}).reduce(0, { $0 + $1 })

print("Part 1: \(total)")

let cards = try! readInputLines(day: 4).map(String.init).map(Card.parse)

var card_counts: [Int: Int] = [:]

for card in cards {
  card_counts[card.index] = 1
}

for card in cards {
  let win_count = card.win_count()
  if win_count > 0 {
    for idx in (card.index + 1)..<(card.index + 1 + win_count) {
      card_counts[idx]! += card_counts[card.index]!
    }
  }
}

let total_cards = card_counts.values.reduce(0, { $0 + $1 })
print("Part 2: \(total_cards)")
