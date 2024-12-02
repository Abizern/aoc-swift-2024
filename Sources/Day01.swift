import Collections
import Foundation
import Parsing

struct Day01: AdventDay, Sendable {
  let data: String
  let day = 1
  let puzzleName: String = "--- Day 1: Historian Hysteria ---"

  init(data: String) {
    self.data = data
  }

  var lists: ([Int], [Int]) {
    parseData(data).reduce(into: ([Int](), [Int]())) { partialResult, pair in
      partialResult.0.append(pair.0)
      partialResult.1.append(pair.1)
    }
  }

  func part1() async throws -> Int {
    let (left, right) = lists
    var leftHeap = Heap(left)
    var rightHeap = Heap(right)

    var result = 0
    while !leftHeap.isEmpty, !rightHeap.isEmpty {
      result += abs(leftHeap.removeMin() - rightHeap.removeMin())
    }

    return result
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
