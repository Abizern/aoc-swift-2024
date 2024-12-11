import Testing

@testable import AdventOfCode

@Suite("Day11 Tests")
struct Day11Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day11(data: testInput1)
      let dict = day.stoneDictionary
      print(dict)
      #expect(dict.count == 5)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day11(data: testInput2)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 55312)
    }
  }
}

private let testInput1 = "0 1 10 99 999"
private let testInput2 = "125 17"
