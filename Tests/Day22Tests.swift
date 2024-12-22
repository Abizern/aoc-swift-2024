import Testing

@testable import AdventOfCode

@Suite("Day22 Tests")
struct Day22Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day22(data: testInput)

    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day22(data: testInput)

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
  """
