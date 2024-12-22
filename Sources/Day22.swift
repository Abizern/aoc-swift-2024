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
