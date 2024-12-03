import Testing

@testable import AdventOfCode

@Suite("Day03 Tests")
struct Day03Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day03(data: testInput)
      #expect(day.pairs.count == 4)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day03(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 161)
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

private let testInput = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
