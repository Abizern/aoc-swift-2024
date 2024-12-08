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
        source.antinodeWidth(target)
      }
      .filter(boundsChecker))
      .count
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

    var description: String {
      "(\(row), \(column))"
    }
  }

  struct Antenna: Hashable {
    let point: Point
    let frequency: Character

    init(_ position: (Int, Int), frequency: Character) {
      point = Point(row: position.0, column: position.1)
      self.frequency = frequency
    }

    func antinodeWidth(_ antenna: Antenna) -> Point? {
      guard frequency == antenna.frequency,
            self != antenna
      else {
        return nil
      }

      let dRow = antenna.point.row - point.row
      let dColumn = antenna.point.column - point.column

      return Point(row: antenna.point.row + dRow, column: antenna.point.column + dColumn)
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
