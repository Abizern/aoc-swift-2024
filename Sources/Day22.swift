import Algorithms
import Foundation
import Parsing

struct Day22: AdventDay, Sendable {
  let data: String
  let day = 22
  let puzzleName: String = "--- Day 22: Monkey Market ---"

  init(data: String) {
    self.data = data
  }

  var rows: [Int] {
    do {
      return try InputParser().parse(data)
    } catch {
      fatalError("Unable to parse data: \(error)")
    }
  }

  func part1() async throws -> Int {
    rows.map(evolvutionFunction(n: 2000)).reduce(0, +)
  }

  func part2() async throws -> Int {
    rows
      .map(evolutionReduction(n: 2000))
      .map(differences)
      .reduce(into: [String: Int]()) { partialResult, dict in
        for key in dict.keys {
          partialResult[key, default: 0] += dict[key] ?? 0
        }
      }
      .values.max() ?? 0
  }
}

extension Day22 {
  func mix(_ number: Int, _ secretNumber: Int) -> Int {
    number ^ secretNumber
  }

  func prune(_ secretNumber: Int) -> Int {
    secretNumber % 16777216
  }

  func next(from: Int) -> Int {
    let a = prune(mix(from * 64, from))
    let b = prune(mix(Int(floor(Double(a) / 32.0)), a))
    let c = prune(mix(b * 2048, b))

    return c
  }

  func evolvutionFunction(n: Int) -> (Int) -> Int {
    { secretNumber in
      var num = secretNumber
      for _ in 0 ..< n {
        num = next(from: num)
      }

      return num
    }
  }

  func evolutionReduction(n: Int) -> (Int) -> [Int] {
    { secretNumber in
      (0 ..< n).reductions(secretNumber) { num, _ in
        next(from: num)
      }
    }
  }

  func differences(_ numbers: [Int]) -> [String: Int] {
    let ones = numbers.map { $0 % 10 }
    var dict: [String: Int] = [:]

    for slice in ones.windows(ofCount: 5) {
      var k: [String] = []
      let v = slice.last!
      for (n, l) in zip(slice.dropFirst(), slice) {
        k.append(String(n - l))
      }
      let key = k.joined(separator: ",")
      guard dict[key] == nil else { continue }
      dict[key] = v
    }
    return dict
  }
}

extension Day22 {
  struct InputParser: Parser {
    var body: some Parser<Substring, [Int]> {
      Many {
        Int.parser()
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }
  }
}
