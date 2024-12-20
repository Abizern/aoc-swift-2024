import Testing

@testable import AdventOfCode

@Suite("Day20 Tests")
struct Day20Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let track = Day20(data: testInput).track
      #expect(track.keys.count == 85)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day20(data: testInput)

    @Test("Count Cheats")
    func countCheats() {
      let track = day.track
      let count = day.countCheats(track, radius: 2, minReduction: 2)
      #expect(count == 44)
    }
  }
}

private let testInput =
  """
  ###############
  #...#...#.....#
  #.#.#.#.#.###.#
  #S#...#.#.#...#
  #######.#.#.###
  #######.#.#...#
  #######.#.###.#
  ###..E#...#...#
  ###.#######.###
  #...###...#...#
  #.#####.#.###.#
  #.#...#.#.#...#
  #.#.#.#.#.#.###
  #...#...#...###
  ###############
  """
