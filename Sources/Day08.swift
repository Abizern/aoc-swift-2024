import Algorithms
import Foundation
import Parsing

struct Day08: AdventDay, Sendable {
  let data: String
  let day = 8
  let puzzleName: String = "--- Day 8: Resonant Collinearity ---"

  init(data: String) {
    self.data = data
  }

  var input: ([Antenna], Boundaries) {
    let rows = parseInput()
    var antennas: [Antenna] = []
    for (r, row) in rows.enumerated() {
      for (c, char) in row.enumerated() {
        guard char != "." else { continue }
        antennas.append(Antenna((r, c), frequency: char))
      }
    }

    let width = rows[0].count
    let height = rows.count

    return (antennas, Boundaries(width: width, height: height))
  }

  func part1() async throws -> Int {
    let (antennas, boundaries) = input
    let boundsChecker = boundsChecker(boundaries)

    return Set(product(antennas, antennas)
      .compactMap { source, target in
        source.antinode(target)
      }
      .filter(boundsChecker))
      .count
  }

  func part2() async throws -> Int {
    let (antennas, boundaries) = input
    let boundsChecker = boundsChecker(boundaries)

    let ans = Set(product(antennas, antennas)
      .compactMap { source, target in
        source.antinodes(target, checker: boundsChecker)
      }
      .flatMap { $0 })
      .count

    return ans
  }
}

extension Day08 {
  func boundsChecker(_ boundaries: Boundaries) -> ((Point) -> Bool) {
    { point in
      point.row >= 0 && point.row < boundaries.height &&
        point.column >= 0 && point.column < boundaries.width
    }
  }
}

extension Day08 {
  struct Boundaries: Equatable {
    let width: Int
    let height: Int
  }

  struct Point: Hashable, CustomStringConvertible {
    let row: Int
    let column: Int

    func offset(_ point: Point) -> Offset {
      Offset(dRow: point.row - row, dCol: point.column - column)
    }

    func add(_ offset: Offset) -> Point {
      Point(row: row + offset.dRow, column: column + offset.dCol)
    }

    var description: String {
      "(\(row), \(column))"
    }
  }

  struct Offset {
    let dRow: Int
    let dCol: Int
  }

  struct Antenna: Hashable {
    let point: Point
    let frequency: Character

    init(_ position: (Int, Int), frequency: Character) {
      point = Point(row: position.0, column: position.1)
      self.frequency = frequency
    }

    func offset(_ antenna: Antenna) -> Offset {
      Offset(dRow: antenna.point.row - point.row, dCol: antenna.point.column - point.column)
    }

    func antinode(_ antenna: Antenna) -> Point? {
      guard frequency == antenna.frequency,
            self != antenna
      else {
        return nil
      }

      let offset = point.offset(antenna.point)
      return antenna.point.add(offset)
    }

    func antinodes(_ antenna: Antenna, checker: (Point) -> Bool) -> [Point]? {
      guard frequency == antenna.frequency,
            self != antenna
      else {
        return nil
      }

      let offset = point.offset(antenna.point)
      var antinodes: [Point] = [antenna.point]
      var antinode = antenna.point.add(offset)

      while checker(antinode) {
        antinodes.append(antinode)
        antinode = antinode.add(offset)
      }

      return antinodes
    }
  }
}

extension Day08 {
  func parseInput() -> [[Character]] {
    do {
      return try Lines().parse(data)
    } catch {
      fatalError("Unable to parse data: \(error)")
    }
  }

  struct Lines: Parser {
    var body: some Parser<Substring, [[Character]]> {
      Many {
        Prefix { $0 != "\n" }.map(Array.init)
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }
  }
}
