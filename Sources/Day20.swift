import Foundation
import Parsing
import Algorithms
import AoCCommon

struct Day20: AdventDay, Sendable {
  let data: String
  let day = 20
  let puzzleName: String = "--- Day 20: Race Condition ---"

  init(data: String) {
    self.data = data
  }

  // (dictionary of distance from start, start, end)
  var track: [Cell: Int] {
    do {
      let rows = try InputParser().parse(data)
      return track(rows)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }

  func part1() async throws -> Int {
    countCheats(track, radius: 2, minReduction: 100)
  }

  func part2() async throws -> Int {
    countCheats(track, radius: 20, minReduction: 100)
  }
}

extension Day20 {
  func track(_ rows: [[Character]]) -> [Cell: Int] {
    let grid = Grid(rows: rows)

    let start = grid.firstCell(for: "S")!
    let end = grid.firstCell(for: "E")!

    var path: [Cell] = []
    var queue: Deque<[Cell]> = [[start]]
    var seen: Set<Cell> = []

    while !queue.isEmpty && path.isEmpty {
      let currentPath = queue.removeFirst()
      let head = currentPath.last!
      if head == end {
        path = currentPath
        continue
      }
      if seen.contains(head) {
        continue
      }
      else {
        seen.insert(head)
      }
      let neighbours = grid.neighbours(head, includeDiagonals: false)
      for neighbour in neighbours {
        guard grid.element(neighbour) != "#",
              !seen.contains(neighbour)
        else {
          continue
        }
        queue.append(currentPath + [neighbour])
      }
    }

    var dict = [Cell: Int]()
    for (distance, position) in path.enumerated() {
      dict[position] = distance
    }

    return dict
  }

  func countCheats(_ track: [Cell:Int], radius: Int, minReduction reduction: Int) -> Int {
    let path = track.sorted { $0.value < $1.value }
    let x = path.map { cell, distance in
      var candidates: Set<Cell> = []
      let targets = targets(from: cell, distance: radius)
      for (c, d) in targets {
        guard let dd = track[c],
              !candidates.contains(c),
              dd >= distance + d + reduction
        else {
          continue
        }
        candidates.insert(c)
      }
      return candidates.count

    }.reduce(0, +)
    return x
  }

  func targets(from: Cell, distance: Int) -> [(Cell, Int)] {
    var cells: [(Cell, Int)] = []
    for r in -distance ... distance {
      for c in -distance ... distance {
        guard abs(r) + abs(c) <= distance
        else {
          continue
        }
        cells.append((Cell(from.row + r, from.col + c), abs(r) + abs(c)))
      }
    }
    return cells
  }

}

// MARK: - Parsing
extension Day20 {
  struct ParseLine: Parser {
    var body: some Parser<Substring, [Character]> {
      Parse(Array.init) {
        Prefix { $0 != "\n" }
      }
    }
  }

  struct InputParser: Parser {
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
