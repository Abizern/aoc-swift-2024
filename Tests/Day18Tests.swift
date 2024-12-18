import Testing

@testable import AdventOfCode

@Suite("Day18 Tests")
struct Day18Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day18(data: testInput)
      #expect(day.points.count == 25)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day18(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      await withKnownIssue {
        let result = try await day.part1()
        #expect(result == 10)
      }
    }

    @Test("Part2 example")
    func testPart2() async throws {
      await withKnownIssue {
        let result = try await day.part2()
        #expect(result == 10)
      }
    }
  }
}

private let testInput =
  """
  5,4
  4,2
  4,5
  3,0
  2,1
  6,3
  2,4
  1,5
  0,6
  3,3
  2,6
  5,1
  1,2
  5,5
  2,5
  6,5
  1,4
  0,4
  6,4
  1,1
  6,1
  1,0
  0,5
  1,6
  2,0
  """
