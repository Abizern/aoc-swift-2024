import Foundation

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
    let pattern = #/mul\((\d+),(\d+)\)/#

    return data
      .matches(of: pattern)
      .map { match -> (Int, Int)? in
        if let a = Int(match.output.1), let b = Int(match.output.2) {
          return (a, b)
        }
        return nil
      }.compactMap { $0 }
  }
}
