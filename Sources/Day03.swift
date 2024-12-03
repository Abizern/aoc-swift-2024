import Foundation
import Parsing

struct Day03: AdventDay, Sendable {
  let data: String
  let day = 3
  let puzzleName: String = "--- Day 3: Mull It Over ---"

  init(data: String) {
    self.data = data
  }

  var pairs: [(Int, Int)] {
    parseInput()
  }

  func part1() async throws -> Int {
    pairs.map { a, b in a * b }.reduce(0, +)
  }
}

extension Day03 {
  func parseInput() -> [(Int, Int)] {
    var result = [(Int, Int)]()
    var data = data[...]
    while !data.isEmpty {
      if let pair = try? MultParser().parse(&data) {
        result.append(pair)
      } else {
        data = data.dropFirst()
      }
    }
    return result
  }
}

struct MultParser: Parser {
  var body: some Parser<Substring, (Int, Int)> {
    "mul("
    Int.parser()
    ","
    Int.parser()
    ")"
  }
}
