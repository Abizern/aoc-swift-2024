import Algorithms
import AoCCommon
import Foundation

struct Day10: AdventDay, Sendable {
  let data: String
  let day = 10
  let puzzleName: String = "--- Day 10: Hoof It ---"

  init(data: String) {
    self.data = data
  }

  var grid: Grid<Int> {
    do {
      return try SingleDigitGridParser().parse(data)
    } catch {
      fatalError("Unable to parse data because \(error)")
    }
  }

  func part1() async throws -> Int {
    trailHeads(grid).map { score(grid, start: $0) }.reduce(0, +)
  }

  func part2() async throws -> Int {
    trailHeads(grid).map { rating(grid, start: $0) }.reduce(0, +)
  }
}

extension Day10 {
  func trailHeads(_ grid: Grid<Int>) -> Set<Cell> {
    grid.filter { $0 == 0 }
  }

  func score(_ grid: Grid<Int>, start: Cell) -> Int {
    var count = 0
    var queue = Deque<Cell>([start])
    var ends = Set<Cell>()

    while !queue.isEmpty {
      let cursor = queue.removeFirst()

      guard let cursorValue = grid.element(cursor),
            cursorValue != 9
      else {
        if !ends.contains(cursor) {
          count += 1
          ends.insert(cursor)
        }
        continue
      }

      let neighbours = grid
        .neighbours(cursor, includeDiagonals: false)
        .filter { grid.element($0)! - cursorValue == 1 }
      queue.append(contentsOf: neighbours)
    }

    return count
  }

  func rating(_ grid: Grid<Int>, start: Cell) -> Int {
    var count = 0
    var queue = Deque<Cell>([start])

    while !queue.isEmpty {
      let cursor = queue.removeFirst()

      guard let cursorValue = grid.element(cursor),
            cursorValue != 9
      else {
        count += 1
        continue
      }

      let neighbours = grid
        .neighbours(cursor, includeDiagonals: false)
        .filter { grid.element($0)! - cursorValue == 1 }
      queue.append(contentsOf: neighbours)
    }

    return count
  }
}
