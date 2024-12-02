import Testing

@testable import AdventOfCode

@Suite("Day02 Tests")
struct Day02Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day02(data: testInput)
      #expect(day.reports.count == 6)
      #expect(day.reports[0] == [7, 6, 4, 2, 1])
    }
  }
  
  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day02(data: testInput)
    
    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 2)
    }
    
    @Test("Part2 example")
    func testPart2() async throws {
      let result = try await day.part2()
      #expect(result == 4)
    }
  }
}

private let testInput =
  """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """
