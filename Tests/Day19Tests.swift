import Testing

@testable import AdventOfCode

@Suite("Day19 Tests")
struct Day19Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day19(data: testInput)
      let (sources, targets) = day.input
      #expect(sources.count == 8)
      #expect(targets.count == 8)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day19(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 6)
    }

    @Test("Part2 example")
    func testPart2() async throws {
      let result = try await day.part2()
      #expect(result == 16)
    }
  }
}

private let testInput =
  """
  r, wr, b, g, bwu, rb, gb, br

  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
  """
