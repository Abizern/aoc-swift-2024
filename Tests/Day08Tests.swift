import Testing

@testable import AdventOfCode

@Suite("Day08 Tests")
struct Day08Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day08(data: testInput)
      let (antennas, boundaries) = day.input
      #expect(boundaries == Day08.Boundaries(width: 12, height: 12))
      #expect(antennas.count == 7)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day08(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 14)
    }

    @Test("Part2 example")
    func testPart2() async throws {
      let result = try await day.part2()
      #expect(result == 34)
    }
  }
}

private let testInput =
  """
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  """
