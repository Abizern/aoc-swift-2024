import Testing

@testable import AdventOfCode

@Suite("Day09 Tests")
struct Day09Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day09(data: testInput)
      let diskMap = day.diskMap
      #expect(diskMap.count == 19)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day09(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 1928)
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

private let testInput = "2333133121414131402"
