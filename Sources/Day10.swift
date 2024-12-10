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
    trailHeads(grid)
      .map { score(grid, start: $0) }
      .reduce(0, +)
  }

  func part2() async throws -> Int {
    trailHeads(grid)
      .map { rating(grid, start: $0) }
      .reduce(0, +)
  }
}

extension Day10 {
  func trailHeads(_ grid: Grid<Int>) -> Set<Cell> {
    grid.filter { $0 == 0 }
  }

  func trailCount(_ grid: Grid<Int>, start: Cell, allPaths: Bool = false) -> Int {
    var count = 0
    var queue = Deque<Cell>([start])
    var ends = Set<Cell>()

    while !queue.isEmpty {
      let cursor = queue.removeFirst()
      let cursorValue = grid.element(cursor)!

      if cursorValue == 9 {
        switch (allPaths, ends.contains(cursor)) {
        case (false, false):
          count += 1
          ends.insert(cursor)
        case (false, true):
          continue
        case (true, _):
          count += 1
          continue
        }
      }

      let neighbours = grid
        .neighbours(cursor, includeDiagonals: false)
        .filter { grid.element($0)! - cursorValue == 1 }
      queue.append(contentsOf: neighbours)
    }

    return count
  }

  func score(_ grid: Grid<Int>, start: Cell) -> Int {
    trailCount(grid, start: start)
  }

  func rating(_ grid: Grid<Int>, start: Cell) -> Int {
    trailCount(grid, start: start, allPaths: true)
  }

}
