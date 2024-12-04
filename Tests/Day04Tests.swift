import Testing

@testable import AdventOfCode

@Suite("Day04 Tests")
struct Day04Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day04(data: testInput)
      let rows = day.rows
      #expect(rows.count == 10)
      #expect(rows[0][0] == "M")
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day04(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 18)
    }

    @Test("Part2 example")
    func testPart2() async throws {
      let result = try await day.part2()
      #expect(result == 9)
    }
  }
}

private let testInput =
  """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """
