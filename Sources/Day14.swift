import Foundation
import Parsing

struct Day14: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 14
  let puzzleName: String = "--- Day 14: Restroom Redoubt ---"

  init(data: String) {
    self.data = data
  }

  var guards: [Guard] {
    do {
      return try GuardsParser().parse(data)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async throws -> Int {
    let positionFn = positionFn(width: 101, height: 103, time: 100)
    let safetyFn = safetyFn(width: 101, height: 103)

    return safetyFn(guards.map(positionFn))
  }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day14 {
  struct Guard: Equatable {
    let px: Int
    let py: Int
    let vx: Int
    let vy: Int

    init(_ values: (Int?, Int?, Int?, Int?)) {
      // I want it to fail if parsing fails.
      px = values.0!
      py = values.1!
      vx = values.2!
      vy = values.3!
    }
  }

  func positionFn(width: Int, height: Int, time n: Int) -> (Guard) -> (Int, Int) {
    { g in
      let newX = mod(g.px + (g.vx * n), width)
      let newY = mod(g.py + (g.vy * n), height)
      return (newX, newY)
    }
  }

  func safetyFn(width: Int, height: Int) -> ([(Int, Int)]) -> Int {
    { positions in
      let (midX, midY) = (width / 2, height / 2)
      let q1 = positions.filter { $0.0 < midX && $0.1 < midY }.count
      let q2 = positions.filter { $0.0 > midX && $0.1 < midY }.count
      let q3 = positions.filter { $0.0 < midX && $0.1 > midY }.count
      let q4 = positions.filter { $0.0 > midX && $0.1 > midY }.count

      return [q1, q2, q3, q4].reduce(1, *)
    }
  }
}

extension Day14 {
  struct GuardParser: Parser {
    var body: some Parser<Substring, Guard> {
      Parse(Guard.init) {
        "p="
        Prefix { $0 != "," }.map { Int($0) }
        ","
        Prefix { $0 != " " }.map { Int($0) }
        " v="
        Prefix { $0 != "," }.map { Int($0) }
        ","
        Prefix { $0 != "\n" }.map { Int($0) }
      }
    }
  }

  struct GuardsParser: Parser {
    var body: some Parser<Substring, [Guard]> {
      Many {
        GuardParser()
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }
  }
}

private func mod(_ x: Int, _ n: Int) -> Int {
  ((x % n) + n) % n
}
