import func aoc2024_shared.readInputLines

enum Day7Error: Error {
  case InvalidCard
}

enum Card: Int, Comparable {
  case N2 = 2
  case N3 = 3
  case N4 = 4
  case N5 = 5
  case N6 = 6
  case N7 = 7
  case N8 = 8
  case N9 = 9
  case T = 10
  case J = 11
  case Q = 12
  case K = 13
  case A = 14

  static func parse(_ c: Character) throws -> Card {
    switch c {
    case "2":
      .N2
    case "3":
      .N3
    case "4":
      .N4
    case "5":
      .N5
    case "6":
      .N6
    case "7":
      .N7
    case "8":
      .N8
    case "9":
      .N9
    case "T":
      .T
    case "J":
      .J
    case "Q":
      .Q
    case "K":
      .K
    case "A":
      .A
    default:
      throw Day7Error.InvalidCard
    }
  }

  static func < (lhs: Card, rhs: Card) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

enum HandType: Int, Comparable {
  case FiveOfAKind = 7
  case FourOfAKind = 6
  case FullHouse = 5
  case ThreeOfAKind = 4
  case TwoPair = 3
  case Pair = 2
  case HighCard = 1

  static func countCards(_ cards: [Card]) -> [Card: Int] {
    var counts: [Card: Int] = [:]
    for card in cards {
      if let curr = counts[card] {
        counts[card] = curr + 1
      } else {
        counts[card] = 1
      }
    }
    return counts
  }

  static func of(_ cards: [Card]) -> Self {
    let counts = HandType.countCards(cards)
    if counts.values.contains(where: { $0 == 5 }) {
      return .FiveOfAKind
    }
    if counts.values.contains(where: { $0 == 4 }) {
      return .FourOfAKind
    }
    if counts.values.contains(where: { $0 == 3 }) && counts.values.contains(where: { $0 == 2 }) {
      return .FullHouse
    }
    if counts.values.contains(where: { $0 == 3 }) {
      return .ThreeOfAKind
    }
    if counts.values.filter({ $0 == 2 }).count == 2 {
      return .TwoPair
    }
    if counts.values.contains(where: { $0 == 2 }) {
      return .Pair
    }
    return .HighCard
  }

  static func < (lhs: HandType, rhs: HandType) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

struct Hand: Comparable {
  var cards: [Card]
  var handType: HandType

  static func parse(_ s: String) throws -> Self {
    var cards: [Card] = []
    for c in s {
      cards.append(try Card.parse(c))
    }
    return Hand(cards: cards, handType: HandType.of(cards))
  }

  static func < (lhs: Hand, rhs: Hand) -> Bool {
    if lhs.handType != rhs.handType {
      return lhs.handType < rhs.handType
    }
    for (l, r) in zip(lhs.cards, rhs.cards) {
      if l != r {
        return l < r
      }
    }
    fatalError("Comparing two hands that are the same.")
  }
}

struct Bid {
  var hand: Hand
  var bid: Int

  static func parse(_ s: String) throws -> Self {
    let parts = s.split(separator: " ")

    return Bid(hand: try Hand.parse(String(parts[0])), bid: Int(parts[1])!)
  }
}

struct Game {
  var bids: [Bid]

  func score() -> Int {
    let sorted = bids.sorted(by: { (a, b) -> Bool in a.hand < b.hand })
    return sorted.enumerated().map({ (rank, bid) -> Int in (rank + 1) * bid.bid }).reduce(
      0,
      {
        $0 + $1
      })
  }
}

let input = try! readInputLines(day: 7)

let game = Game(bids: try! input.map({ String($0) }).map(Bid.parse))

print("Part 1: \(game.score())")

enum JCard: Int, Comparable {
  case J = 1
  case N2 = 2
  case N3 = 3
  case N4 = 4
  case N5 = 5
  case N6 = 6
  case N7 = 7
  case N8 = 8
  case N9 = 9
  case T = 10
  case Q = 11
  case K = 12
  case A = 13

  static func parse(_ c: Character) throws -> JCard {
    switch c {
    case "2":
      .N2
    case "3":
      .N3
    case "4":
      .N4
    case "5":
      .N5
    case "6":
      .N6
    case "7":
      .N7
    case "8":
      .N8
    case "9":
      .N9
    case "T":
      .T
    case "J":
      .J
    case "Q":
      .Q
    case "K":
      .K
    case "A":
      .A
    default:
      throw Day7Error.InvalidCard
    }
  }

  func toString() -> String {
    switch self {
    case .N2:
      "2"

    case .J:
      "J"

    case .N3:
      "3"

    case .N4:
      "4"

    case .N5:
      "5"

    case .N6:
      "6"

    case .N7:
      "7"

    case .N8:
      "8"

    case .N9:
      "9"

    case .T:
      "T"

    case .Q:
      "Q"

    case .K:
      "K"

    case .A:
      "A"
    }
  }

  static func < (lhs: JCard, rhs: JCard) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

enum JHandType: Int, Comparable {
  case FiveOfAKind = 7
  case FourOfAKind = 6
  case FullHouse = 5
  case ThreeOfAKind = 4
  case TwoPair = 3
  case Pair = 2
  case HighCard = 1

  static func countCards(_ cards: [JCard]) -> [JCard: Int] {
    var counts: [JCard: Int] = [:]
    for card in cards {
      if let curr = counts[card] {
        counts[card] = curr + 1
      } else {
        counts[card] = 1
      }
    }
    return counts
  }

  static func of(_ cards: [JCard]) -> Self {
    let counts = JHandType.countCards(cards)
    let jokerCount = counts[JCard.J] ?? 0
    let nonJokerCounts = counts.filter({ (pair) -> Bool in pair.0 != .J })
    if counts.values.contains(where: { $0 == 5 })
      || nonJokerCounts.values.contains(where: { $0 == 5 - jokerCount })
    {
      return .FiveOfAKind
    }
    if counts.values.contains(where: { $0 == 4 })
      || nonJokerCounts.values.contains(where: { $0 == 4 - jokerCount })
    {
      return .FourOfAKind
    }
    if (counts.values.contains(where: { $0 == 3 }) && counts.values.contains(where: { $0 == 2 }))
      || (nonJokerCounts.values.contains(where: { $0 == 3 })
        && nonJokerCounts.values.contains(where: { $0 == 2 - jokerCount }))
      || (jokerCount > 0
        && nonJokerCounts.values.filter({ $0 == 2 || $0 == 3 - jokerCount }).count == 2)
      || (jokerCount == 3)
      || (jokerCount == 2 && nonJokerCounts.values.contains(where: { $0 == 2 }))
    {
      return .FullHouse
    }
    if counts.values.contains(where: { $0 == 3 })
      || nonJokerCounts.values.contains(where: { $0 == 3 - jokerCount })
    {
      return .ThreeOfAKind
    }
    if counts.values.filter({ $0 == 2 }).count == 2
      || counts.values.filter({ $0 == 2 || $0 == 2 - jokerCount }).count == 2
      || (jokerCount == 2)
    {
      return .TwoPair
    }
    if counts.values.contains(where: { $0 == 2 }) || (jokerCount == 1) {
      return .Pair
    }
    return .HighCard
  }

  static func < (lhs: JHandType, rhs: JHandType) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

struct JHand: Comparable {
  var cards: [JCard]
  var handType: JHandType

  static func parse(_ s: String) throws -> Self {
    var cards: [JCard] = []
    for c in s {
      cards.append(try JCard.parse(c))
    }
    return JHand(cards: cards, handType: JHandType.of(cards))
  }

  static func < (lhs: JHand, rhs: JHand) -> Bool {
    if lhs.handType != rhs.handType {
      return lhs.handType < rhs.handType
    }
    for (l, r) in zip(lhs.cards, rhs.cards) {
      if l != r {
        return l < r
      }
    }
    fatalError("Comparing two hands that are the same.")
  }

  func toString() -> String {
    "\(cards[0].toString())\(cards[1].toString())\(cards[2].toString())\(cards[3].toString())\(cards[4].toString()) -> \(handType)"
  }
}

struct JBid {
  var hand: JHand
  var bid: Int

  static func parse(_ s: String) throws -> Self {
    let parts = s.split(separator: " ")

    return JBid(hand: try JHand.parse(String(parts[0])), bid: Int(parts[1])!)
  }
}

struct JGame {
  var bids: [JBid]

  func score() -> Int {
    let sorted = bids.sorted(by: { (a, b) -> Bool in a.hand < b.hand })
    return sorted.enumerated().map({ (rank, bid) -> Int in (rank + 1) * bid.bid }).reduce(
      0,
      {
        $0 + $1
      })
  }
}

let jgame = JGame(bids: try! input.map({ String($0) }).map(JBid.parse))

print("Part 2: \(jgame.score())")

// let testInput = [
//   "32T3K 765",
//   "T55J5 684",
//   "KK677 28",
//   "KTJJT 220",
//   "QQQJA 483",
// ]

// for item in jgame.bids {
//   print(item.hand.toString())
// }

// let testGame = JGame(bids: try! testInput.map({ String($0) }).map(JBid.parse))
// print(testGame)
// print("Test part 2: \(testGame.score())")
