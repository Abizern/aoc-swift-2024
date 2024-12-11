import AoCCommon
import Foundation

struct Day11: AdventDay, Sendable {
  let data: String
  let day = 11
  let puzzleName: String = "--- Day 11: Plutonian Pebbles ---"

  init(data: String) {
    self.data = data
  }

  var stoneDictionary: [Int: Int] {
    do {
      let numbers = try NumberLine(separator: " ").parse(data)
      return Dictionary(grouping: numbers, by: { $0 }).mapValues(\.count)
    } catch {
      fatalError("Could not parse input \(error)")
    }
  }

  func part1() async throws -> Int {
    stepper(stoneDictionary, blinks: 25)
  }

  func part2() async throws -> Int {
    stepper(stoneDictionary, blinks: 75)
  }
}

extension Day11 {
  func stepper(_ dict: [Int: Int], blinks: Int) -> Int {
    var dict = dict
    for _ in 0 ..< blinks {
      dict = step(dict)
    }

    return dict.values.reduce(0, +)
  }

  func step(_ dict: [Int: Int]) -> [Int: Int] {
    var keys = dict.keys.filter { $0 != 0 }.map { ($0, String($0)) }
    let partitionIndex = keys.partition { $0.1.count % 2 == 1 }
    var accum = [Int: Int]()

    if let zeroes = dict[0] {
      accum[1] = zeroes
    }

    // even length keys
    for pair in keys[0 ..< partitionIndex] {
      let (key, strKey) = pair
      let count = dict[key]!
      let midpoint = strKey.count / 2

      accum[Int(strKey.prefix(midpoint))!, default: 0] += count
      accum[Int(strKey.suffix(midpoint))!, default: 0] += count
    }

    for pair in keys[partitionIndex ..< keys.count] {
      let key = pair.0
      let newKey = key * 2024
      let value = dict[key]!

      accum[newKey, default: 0] += value
    }

    return accum
  }
}
