import Foundation
import Parsing

struct Day19: AdventDay, Sendable {
  let data: String
  let day = 19
  let puzzleName: String = "--- Day 19: Linen Layout ---"

  init(data: String) {
    self.data = data
  }

  var input: ([String], [String]) {
    do {
      return try InputParser().parse(data)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }

  func part1() async throws -> Int {
    var cache: [String: Bool] = [:]
    let (sources, targets) = input
    return targets.map { isValid($0, from: sources, cache: &cache) }.filter { $0 }.count
  }

  func part2() async throws -> Int {
    var cache: [String: Int] = [:]
    let (sources, targets) = input
    return targets.map { countMatches($0, from: sources, cache: &cache) }.reduce(0, +)
  }
}

extension Day19 {
  func isValid(_ target: String, from sources: [String], cache: inout [String: Bool]) -> Bool {
    if target.isEmpty { return true }
    if let cached = cache[target] { return cached }

    let candidates = sources.filter { target.hasPrefix($0) }.map(\.count)
    guard !candidates.isEmpty else {
      return false
    }
    for length in Set(candidates) {
      let newTarget = String(target.dropFirst(length))
      if isValid(newTarget, from: sources, cache: &cache) {
        cache[newTarget] = true
        return true
      } else {
        cache[newTarget] = false
      }
    }
    return false
  }

  func countMatches(_ target: String, from sources: [String], cache: inout [String: Int]) -> Int {
    if target.isEmpty { return 1 }
    if let cached = cache[target] { return cached }

    let candidates = sources.filter { target.hasPrefix($0) }
    guard !candidates.isEmpty else {
      return 0
    }

    var counts = 0
    for candidate in candidates {
      let newTarget = String(target.dropFirst(candidate.count))
      let count = countMatches(newTarget, from: sources, cache: &cache)
      if count > 0 {
        cache[newTarget] = count
        counts += count
      } else {
        cache[newTarget] = 0
      }
    }

    return counts
  }
}

extension Day19 {
  struct InputParser: Parser {
    var body: some Parser<Substring, ([String], [String])> {
      Many {
        CharacterSet.alphanumerics.map { String($0) }
      } separator: {
        ", "
      } terminator: {
        "\n"
      }
      "\n"
      Many {
        CharacterSet.alphanumerics.map(String.init)
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }
  }
}
