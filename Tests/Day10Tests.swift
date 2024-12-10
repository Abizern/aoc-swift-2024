import AoCCommon
import Testing

@testable import AdventOfCode

@Suite("Day10 Tests")
struct Day10Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let grid = Day10(data: testInput).grid
      #expect(grid.width == 8)
      #expect(grid.height == 8)
    }
  }

  @Suite("Supplementary functions")
  struct SupplementaryFunctionsTests {
    @Test("Trailheads")
    func trailheads() {
      let day = Day10(data: testInput)
      #expect(day.trailHeads(day.grid).count == 9)
    }

    @Test("TrailCount")
    func trailCount() {
      let day = Day10(data: testInput)
      let grid = day.grid
      #expect(day.trailCount(grid, start: Cell(0, 2), allPaths: false) == 5)
      #expect(day.trailCount(grid, start: Cell(0, 4), allPaths: false) == 6)
      #expect(day.trailCount(grid, start: Cell(0, 2), allPaths: true) == 20)
      #expect(day.trailCount(grid, start: Cell(0, 4), allPaths: true) == 24)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day10(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 36)
    }

    @Test("Part2 example")
    func testPart2() async throws {
      let result = try await day.part2()
      #expect(result == 81)
    }
  }
}

private let testInput =
  """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """
