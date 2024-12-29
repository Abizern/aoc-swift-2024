import Testing

@testable import AdventOfCode

@Suite("Day25 Tests")
struct Day25Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day25(data: testInput)
      let inputs = day.inputs
      #expect(inputs.count == 5)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day25(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 3)
    }
  }
}

private let testInput =
  """
  #####
  .####
  .####
  .####
  .#.#.
  .#...
  .....

  #####
  ##.##
  .#.##
  ...##
  ...#.
  ...#.
  .....

  .....
  #....
  #....
  #...#
  #.#.#
  #.###
  #####

  .....
  .....
  #.#..
  ###..
  ###.#
  ###.#
  #####

  .....
  .....
  .....
  #....
  #.#..
  #.#.#
  #####
  """
