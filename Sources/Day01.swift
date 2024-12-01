import Foundation
import Parsing

struct Day01: AdventDay, Sendable {
  let data: String
  let day = 0
  let puzzleName: String = "--- Day 1: Historian Hysteria ---"

  init(data: String) {
    self.data = data
  }

  var pairs: [(Int, Int)] {
    parseData(data)
  }

  var lists: ([Int], [Int]) {
    pairs.reduce(into: ([Int](), [Int]())) { partialResult, pair in
      partialResult.0.append(pair.0)
      partialResult.1.append(pair.1)
    }
  }

  func part1() async throws -> Int {
    zip(lists.0.sorted(), lists.1.sorted()).map { left, right in
      abs(left - right)
    }
    .reduce(0, +)
  }

  func part2() async throws -> Int {
    let (left, right) = lists
    let counts = Dictionary(grouping: right, by: { $0 }).mapValues(\.count)

    let simililarities = left.reduce(into: 0) { partialResult, l in
      let n = counts[l, default: 0]
      partialResult += l * n
    }

    return simililarities
  }
}

extension Day01 {
  func parseData(_ data: String) -> [(Int, Int)] {
    let pairs = Parse(input: Substring.self) {
      Many {
        Digits()
        "   "
        Digits()
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }

    do {
      return try pairs.parse(data)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }
}
