import Foundation
import Parsing

struct Day06: AdventDay, Sendable {
  let data: String
  let day = 6
  let puzzleName: String = "--- Day 6: Guard Gallivant ---"

  init(data: String) {
    self.data = data
  }

  var rows: [[Character]] {
    parseInput()
  }

  func part1() async throws -> Int {
    let (obstacles, grd) = extractObjects(rows)
    let result = pathResult(rows, obstacles: obstacles, visited: Set(), grd: grd)
    guard case .exited(let visited) = result else {
      fatalError("There should not be a loop in part 1")
    }

    return visited.count
  }

  func part2() async throws -> Int {
    let width = rows[0].count
    let height = rows.count
    let objects = extractObjects(rows)
    let obstacles = objects.0
    var grd = objects.1
    var visited = Set<Guard>()
    var count = 0

    while (0 ..< width).contains(grd.position.col), (0 ..< height).contains(grd.position.row) {
      visited.insert(grd)

      // Branch off by turning right and seeing if there is a loop
      let turned = grd.turned
      if shouldBranch(turned, obstacles: obstacles) {
        if case .looped = pathResult(rows, obstacles: obstacles, visited: visited, grd: turned) {
          count += 1
        }
      }

      var next = grd.moved
      if obstacles.contains(next.position) {
        next = turned
      }
      grd = next
    }

    return count
  }

  func shouldBranch(_ grd: Guard, obstacles: Set<Position>) -> Bool {
    let row = grd.position.row
    let col = grd.position.col

    switch grd.direction {
    case .up
      where obstacles.filter { $0.col == col }.filter { $0.row < row }.count > 0:
      return true
    case .right
      where obstacles.filter { $0.row == row }.filter { $0.col > col }.count > 0:
      return true
    case .down
      where obstacles.filter { $0.col == col }.filter { $0.row > row }.count > 0:
      return true
    case .left
      where obstacles.filter { $0.row == row }.filter { $0.col < col }.count > 0:
      return true
    default:
      break
    }

    return false
  }
}

extension Day06 {
  func pathResult(_ rows: [[Character]], obstacles: Set<Position>, visited: Set<Guard>, grd: Guard) -> PathResult {
    let width = rows[0].count
    let height = rows.count
    var grd = grd
    var visited = visited

    while (0 ..< width).contains(grd.position.col), (0 ..< height).contains(grd.position.row) {
      guard !visited.contains(grd)
      else {
        return PathResult.looped
      }

      visited.insert(grd)
      var next = grd.moved
      if obstacles.contains(next.position) {
        next = grd.turned
      }
      grd = next
    }

    return PathResult.exited(Set(visited.map(\.position)))
  }
}

extension Day06 {
  struct Position: Hashable {
    let row: Int
    let col: Int
  }

  enum Direction {
    case up, right, down, left

    var turn: Direction {
      switch self {
      case .up: .right
      case .right: .down
      case .down: .left
      case .left: .up
      }
    }
  }

  struct Guard: Hashable {
    let position: Position
    let direction: Direction

    init(_ position: (Int, Int), direction: Direction = .up) {
      self.position = Position(row: position.0, col: position.1)
      self.direction = direction
    }

    var moved: Guard {
      switch direction {
      case .up: Guard((position.row - 1, position.col), direction: direction)
      case .right: Guard((position.row, position.col + 1), direction: direction)
      case .down: Guard((position.row + 1, position.col), direction: direction)
      case .left: Guard((position.row, position.col - 1), direction: direction)
      }
    }

    var turned: Guard {
      switch direction {
      case .up: Guard((position.row, position.col), direction: .right)
      case .right: Guard((position.row, position.col), direction: .down)
      case .down: Guard((position.row, position.col), direction: .left)
      case .left: Guard((position.row, position.col), direction: .up)
      }
    }
  }

  enum PathResult: Equatable {
    case exited(Set<Position>)
    case looped
  }
}

extension Day06 {
  func extractObjects(_ rows: [[Character]]) -> (Set<Position>, Guard) {
    var obstacles: [Position] = []
    var grd = Guard((0, 0))

    for (r, row) in rows.enumerated() {
      for (c, char) in row.enumerated() {
        switch char {
        case "#": obstacles.append(Position(row: r, col: c))
        case "^": grd = Guard((r, c))
        default: break
        }
      }
    }

    return (Set(obstacles), grd)
  }
}

// MARK: Parsing

extension Day06 {
  func parseInput() -> [[Character]] {
    do {
      return try Lines().parse(data)
    } catch {
      fatalError("Unable to parse data: \(error)")
    }
  }

  struct ParseLine: Parser {
    var body: some Parser<Substring, [Character]> {
      Parse(Array.init) {
        Prefix { $0 != "\n" }
      }
    }
  }

  struct Lines: Parser {
    var body: some Parser<Substring, [[Character]]> {
      Many {
        ParseLine()
      } separator: {
        "\n"
      } terminator: {
        End()
      }
    }
  }
}
