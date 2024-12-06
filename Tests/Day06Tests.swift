import Testing

@testable import AdventOfCode

@Suite("Day06 Tests")
struct Day06Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day06(data: testInput)
      let rows = day.rows
      #expect(rows.count == 10)
      #expect(rows[0][0] == ".")
      #expect(rows[9][9] == ".")
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day06(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 41)
    }

    @Test("Part2 example")
    func testPart2() async throws {
      let result = try await day.part2()
      #expect(result == 6)
    }
  }
}

private let testInput =
  """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """
