import AoCCommon
import Foundation
import Parsing

struct Day14: AdventDay, Sendable {
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

  func part1() async throws -> Int {
    let positionFn = positionFn(width: 101, height: 103, time: 100)
    let safetyFn = safetyFn(width: 101, height: 103)

    return safetyFn(guards.map(positionFn))
  }

  func part2() async throws -> Int {
    var minSafety = Int.max
    var iteration = 0
    let safetyFn = safetyFn2(width: 101, height: 103)
    let range = 101 * 103 // after this things will be repeatin themselves
    var guards = guards

    for n in 0 ..< range {
      let currentSafety = safetyFn(guards)
      if currentSafety < minSafety {
        minSafety = currentSafety
        iteration = n
      }
      guards = guards.map(\.advance)
    }
    return iteration
  }
}

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

    // Hard coding values, as there are no tests
    var advance: Guard {
      let newX = mod(px + vx, 101)
      let newY = mod(py + vy, 103)

      return Guard((newX, newY, vx, vy))
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

  func safetyFn2(width: Int, height: Int) -> ([Guard]) -> Int {
    { gs in
      let (midX, midY) = (width / 2, height / 2)
      let q1 = gs.filter { $0.px < midX && $0.py < midY }.count
      let q2 = gs.filter { $0.px > midX && $0.py < midY }.count
      let q3 = gs.filter { $0.px < midX && $0.py > midY }.count
      let q4 = gs.filter { $0.px > midX && $0.py > midY }.count

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

extension Day14 {
  func printResult(_ n: Int) -> String {
    var guards = guards
    for _ in 0 ..< n {
      guards = guards.map(\.advance)
    }
    let positions = Set(guards.map { Cell($0.py, $0.px) })

    var output = ""
    for r in 0 ..< 103 {
      var str = ""
      for c in 0 ..< 101 {
        if positions.contains(Cell(r, c)) {
          str.append("#")
        } else {
          str.append(".")
        }
      }
      output += "\(str)\n"
    }
    return output
  }
}
