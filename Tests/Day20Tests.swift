import Testing

@testable import AdventOfCode

@Suite("Day20 Tests")
struct Day20Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let rows = Day20(data: testInput).rows
      #expect(rows.count == 15)
      #expect(rows[0].count == 15)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day20(data: testInput)

    @Test("Solution")
    func solution() async throws {
      let result = day.bruteForce(from: day.rows, target: 4)
      #expect(result == 30)
    }

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
