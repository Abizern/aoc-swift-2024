import Foundation
import Parsing

struct Day05: AdventDay, Sendable {
  let data: String
  let day = 5
  let puzzleName: String = "--- Day 5: Print Queue ---"

  init(data: String) {
    self.data = data
  }

  var parsedInput: ([(Int, Int)], [[Int]]) {
    do {
      return try InputParser().parse(data)
    } catch {
      fatalError("Unable to parse data: \(error)")
    }
  }

  func part1() async throws -> Int {
    let (rules, pages) = parsedInput
    let ordering = ordering(rules)

    return pages
      .filter(isValidFuntion(ordering))
      .map(middleValue)
      .reduce(0, +)
  }

  func part2() async throws -> Int {
    let (rules, pages) = parsedInput
    let ordering = ordering(rules)

    return pages
      .filter(isInvalidFuntion(ordering))
      .map { $0.sorted(by: sortingFunction(ordering)) }
      .map(middleValue)
      .reduce(0, +)
  }
}

extension Day05 {
  struct Pair: Hashable {
    let first: Int
    let second: Int

    init(_ first: Int, _ second: Int) {
      self.first = first
      self.second = second
    }
  }

  func ordering(_ rules: [(Int, Int)]) -> [Pair: Bool] {
    var dict: [Pair: Bool] = [:]
    dict.reserveCapacity(rules.count * 2)
    for (first, second) in rules {
      dict[Pair(first, second)] = true
      dict[Pair(second, first)] = false
    }

    return dict
  }

  func isValidFuntion(_ ordering: [Pair: Bool]) -> ([Int]) -> Bool {
    { pages in
      let pageCount = pages.count
      for i in 0 ..< pageCount - 1 {
        for j in i + 1 ..< pageCount {
          let pair = Pair(pages[i], pages[j])
          if ordering[pair] ?? true {
            continue
          } else {
            return false
          }
        }
      }
      return true
    }
  }

  func isInvalidFuntion(_ ordering: [Pair: Bool]) -> ([Int]) -> Bool {
    { pages in
      let f = isValidFuntion(ordering)
      return !f(pages)
    }
  }

  func sortingFunction(_ ordering: [Pair: Bool]) -> ((Int, Int) -> Bool) {
    { first, second in
      ordering[Pair(first, second)] ?? true
    }
  }

  func middleValue(_ list: [Int]) -> Int {
    list[list.count / 2]
  }
}

// MARK: Parsing

extension Day05 {
  struct RuleParser: Parser {
    var body: some Parser<Substring, (Int, Int)> {
      Int.parser()
      "|"
      Int.parser()
    }
  }

  struct RulesParser: Parser {
    var body: some Parser<Substring, [(Int, Int)]> {
      Many {
        RuleParser()
      } separator: {
        "\n"
      }
    }
  }

  struct LineParser: Parser {
    var body: some Parser<Substring, [Int]> {
      Many {
        Int.parser()
      } separator: {
        ","
      }
    }
  }

  struct InputParser: Parser {
    var body: some Parser<Substring, ([(Int, Int)], [[Int]])> {
      RulesParser()
      "\n\n"
      Many {
        LineParser()
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }
  }
}
