import Testing

@testable import AdventOfCode

@Suite("Day01 Tests")
struct Day01Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day01(data: testInput)
      #expect(day.lists.0 == [3, 4, 2, 1, 3, 3])
      #expect(day.lists.1 == [4, 3, 5, 3, 9, 3])
    }
  }


  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day01(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 11)
    }

    @Test("Part2 example")
    func testPart2() async throws {
      let result = try await day.part2()
      #expect(result == 31)
    }
  }
}

private let testInput =
  """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """
